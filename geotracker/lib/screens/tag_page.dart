import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotracker/provider/map_state.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/location_picker.dart';

import 'package:geotracker/style/map_style.dart';
import 'package:geotracker/widgets/tag_method_picker.dart';
import 'package:geotracker/widgets/map_canvas.dart';
import 'package:geotracker/style/custom_text_style.dart';

class TagPage extends ConsumerStatefulWidget {
  const TagPage({super.key});

  @override
  ConsumerState<TagPage> createState() => _TagPageState();
}

class _TagPageState extends ConsumerState<TagPage> {
  LocationData? pickedLocation;

  bool showMap = true; // Show Map or Location Pick Image

  void handleLocationData(LocationData location) {
    setState(() {
      pickedLocation = location;
      showMap = false;
    });
  }

  void _addNewGeoTag(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) => TagMethodPicker(
        mainContext: context,
        handleLocation: handleLocationData,
      ),
    );
  }

  String mapStyle = MapStyle().silver;

  void changeMapStyle(String style) {
    switch (style) {
      case 'light-grey':
        setState(() {
          mapStyle = MapStyle().silver;
        });
        break;
      case 'light-green':
        setState(() {
          mapStyle = MapStyle().lightGreen;
        });
        break;
      case 'dark-blue':
        setState(() {
          mapStyle = MapStyle().darkDefault;
        });
        break;
    }
  }

  // Get User Information for future use
  NetworkImage? userProfileImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final userProfileImageUrl = documentSnapshot.get('image_url');
          if (userProfileImageUrl != null) {
            userProfileImage = NetworkImage(userProfileImageUrl as String);
          }
          final userNameData = documentSnapshot.get('username');
          if (userNameData != null) {
            userName = userNameData as String;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPicking =
        ref.watch(pickerStateProvider.select((state) => state.isPicking));

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.2,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              top: BorderSide(
                width: 0.2,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              left: BorderSide(
                width: 0.2,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              right: BorderSide(
                width: 0.2,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
            ),
          ),
          height: 500,
          width: 360,
          child: MapCanvas(
            mapStyle: mapStyle,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        isPicking
            ? Padding(
                padding: const EdgeInsets.fromLTRB(120, 32, 120, 16),
                child: Column(
                  children: [
                    Text(
                      'Pick The Location.',
                      style: CustomTextStyle.mediumBoldBlackText,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 192, 192, 192),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(5),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        ref.read(pickerStateProvider.notifier).stopPicking();
                        ref.read(mapStateProvider.notifier).clearLocation();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              )
            : Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(80, 7, 120, 1),
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                // alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () => _addNewGeoTag(context),
                  icon: const Icon(
                    Icons.add,
                    size: 40,
                    weight: 700,
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 200, 200, 200)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white;
                      }
                      return const Color.fromRGBO(80, 7, 120, 1);
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromRGBO(80, 7, 120, 1);
                      }
                      return Colors.white;
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const Color.fromRGBO(80, 7, 120, 0.5);
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
              ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
