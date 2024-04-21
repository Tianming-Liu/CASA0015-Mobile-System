// ignore_for_file: unused_field, avoid_print

import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/map_state.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:geotracker/style/custom_text_style.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/widgets/create_geodata/image_input.dart';
import 'package:geotracker/models/airqualityinfo.dart';

class CreateTagPage extends ConsumerStatefulWidget {
  final LocationData locationData;
  const CreateTagPage({super.key, required this.locationData});

  @override
  ConsumerState<CreateTagPage> createState() => _CreateTagPageState();
}

class _CreateTagPageState extends ConsumerState<CreateTagPage> {
  final _noteController = TextEditingController();

  File? _selectedImage;

  String? _decodedAddress;

  String? _airQuality;

  String? _airQualityForDisplay;

  bool _isLoading = false;

  bool _isFetchingAirQuality = false;

  String? apiKey;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void getDecodeAddress(LocationData locationData) async {
    setState(() {
      _isLoading = true;
    });

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    apiKey = dotenv.env['MAP_API_KEY'] ?? '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    final responce = await http.get(url);

    if (!mounted) return;

    final geoCodeData = json.decode(responce.body);
    if (geoCodeData['results'].isNotEmpty) {
      _decodedAddress = geoCodeData['results'][0]['formatted_address'];
      print(_decodedAddress);
    } else {
      _decodedAddress = "No Location Found";
    }

    setState(() {
      _isLoading = false;
    });
  }

  void getAirQualityData(LocationData locationData) async {
    setState(() {
      _isFetchingAirQuality = true;
    });

    final lat = locationData.latitude!;
    final lng = locationData.longitude!;
    // String apiKey = dotenv.env['AIR_API_KEY'] ?? '';
    Uri apiUrl = Uri.parse(
        'https://airquality.googleapis.com/v1/history:lookup?key=$apiKey');

    print('calling api, $apiUrl');

    try {
      var response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hours': 24,
          'location': {
            'latitude': lat,
            'longitude': lng,
          },
        }),
      );

      if (response.statusCode == 200) {
        var airQualityData = json.decode(response.body);
        _airQuality = response.body;
        if (airQualityData['hoursInfo'].isNotEmpty) {
          List<AirQualityInfo> hoursInfo = (airQualityData['hoursInfo'] as List)
              .map((item) => AirQualityInfo.fromJson(item))
              .toList();
          AirQualityInfo firstHourInfo = hoursInfo[0];
          _airQualityForDisplay = firstHourInfo.indexes[0].category;
          for (var hour in hoursInfo) {
            print("DateTime: ${hour.dateTime}");
            for (var index in hour.indexes) {
              print("AQI: ${index.aqi}, Category: ${index.category}");
            }
          }
        } else {
          _airQuality = "No Data Found";
        }
      } else {
        print('Failed to fetch air quality data: ${response.body}');
      }
    } catch (e) {
      print('Exception when calling API: $e');
    }

    setState(() {
      _isFetchingAirQuality = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDecodeAddress(widget.locationData);
    getAirQualityData(widget.locationData);
  }

  void _saveData() async {
    final enteredNote = _noteController.text;
    final enteredType = dropDownType.toString().split('.').last;
    final time = DateTime.now();

    if (enteredNote.isEmpty || enteredType.isEmpty || _selectedImage == null) {
      return;
    }

    var id = const Uuid().v4();

    final user = FirebaseAuth.instance.currentUser!;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return; // Check if the widget is still active

      ref.read(userRecordProvider.notifier).addPlaceRecord(
          user.uid,
          id,
          dropDownType,
          TagType.place,
          time,
          enteredNote,
          _airQuality!,
          widget.locationData,
          _decodedAddress!,
          _selectedImage!);

      if (!mounted) return;

      // Initialize the storage reference
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_data')
          .child(user.uid)
          .child('$id.jpg');

      // Upload the image to the storage
      await storageRef.putFile(_selectedImage!);
      // Get the image URL for future usage
      final imageUrl = await storageRef.getDownloadURL();

      if (!mounted) return;

      FirebaseFirestore.instance
          .collection('locationData')
          .doc(user.uid)
          .collection('tag')
          .add({
        'id': id,
        'category': enteredType,
        'note': enteredNote,
        'time': time.toIso8601String(),
        'aqi': _airQuality,
        'location':
            'lat:${widget.locationData.latitude.toString()},lng:${widget.locationData.longitude.toString()}',
        'address': _decodedAddress,
        'image_url': imageUrl,
        'username': userData['username'],
      });
      _noteController.clear();

      Navigator.pop(context);
    } catch (e) {
      print("Error during Firebase operation: $e");
    }
  }

  Category dropDownType = Category.leisure;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Location: ',
                          style: CustomTextStyle.smallBoldGreyText,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isLoading)
                              const SizedBox(
                                height: 10,
                                width: 50,
                                child: LinearProgressIndicator(),
                              )
                            else if (_decodedAddress != null)
                              SizedBox(
                                width: 142,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    _decodedAddress!,
                                    textAlign: TextAlign.left,
                                    style: CustomTextStyle.smallBoldBlackText,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.locationData.latitude.toString().substring(0, 6)}, ${widget.locationData.longitude.toString().substring(0, 6)}',
                              style: CustomTextStyle.smallBoldGreyText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'AirQuality: ',
                          style: CustomTextStyle.smallBoldGreyText,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isFetchingAirQuality)
                              const SizedBox(
                                height: 10,
                                width: 50,
                                child: LinearProgressIndicator(),
                              )
                            else if (_airQualityForDisplay != null)
                              Text(
                                _airQualityForDisplay!,
                                textAlign: TextAlign.left,
                                style: CustomTextStyle.smallBoldBlackText,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Category: ',
                          style: CustomTextStyle.smallBoldGreyText,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 200, 200, 200),
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.only(right: 10),
                          child: DropdownButton<Category>(
                            isDense: true,
                            isExpanded: true,
                            value: dropDownType,
                            icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined),
                            iconSize: 20,
                            onChanged: (Category? value) {
                              setState(() {
                                dropDownType = value!;
                              });
                            },
                            style: CustomTextStyle.smallBoldBlackText,
                            items: Category.values
                                .map<DropdownMenuItem<Category>>(
                                    (Category value) {
                              return DropdownMenuItem<Category>(
                                value: value,
                                child: Text(value
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase()),
                              );
                            }).toList(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 35,
                ),
                //Image Input Widget for the user to select an image
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                // UserImagePicker(
                //   onPickImage: (image) {
                //     _selectedImage = image;
                //   },
                // ),
              ],
            ),
            // const SizedBox(
            //   height: 0,
            // ),
            // Image Input
            TextField(
              controller: _noteController,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              style: CustomTextStyle.smallBoldBlackText,
              decoration: InputDecoration(
                labelText: 'Write some notes for your new record.',
                labelStyle: CustomTextStyle.smallBoldGreyText,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(mapStateProvider.notifier).clearLocation();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveData();
                    ref.read(mapStateProvider.notifier).clearLocation();
                  },
                  child: const Text('Save Record'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
