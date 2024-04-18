import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/map_state.dart';
import 'package:location/location.dart';

import 'package:geotracker/widgets/create_geodata/create_tag.dart';

class TagMethodPicker extends ConsumerStatefulWidget {
  final BuildContext mainContext;

  final Function(LocationData) handleLocation; // Callback Function
  const TagMethodPicker(
      {super.key, required this.mainContext, required this.handleLocation});

  @override
  ConsumerState<TagMethodPicker> createState() => _TagMethodPickerState();
}

class _TagMethodPickerState extends ConsumerState<TagMethodPicker> {
  LocationData? locationData;

  final ButtonStyle buttonStyleforNewTag = ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
    backgroundColor: MaterialStateProperty.all<Color>(
      const Color.fromRGBO(80, 7, 120, 1),
    ), // Background Color
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)), //
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Round Radius
      ),
    ),
  );

  final TextStyle textStyleforNewTag = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  // code for location picker

  Location? pickedLocation;
  // ignore: unused_field
  var _isGettingLocation = false;

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    if (!mounted) return;

    locationData = await location.getLocation();

    if (!mounted) return;

    setState(() {
      _isGettingLocation = false;
    });

    // print(locationData!.latitude);
    // print(locationData!.longitude);
    // Only proceed if location data is not null
    if (locationData != null) {
      // Make sure to use context of current widget tree
      Navigator.of(context).pop(); // Close current modal if open
      _showCreateTagBottomSheet(context, locationData!);
      ref.read(mapStateProvider.notifier).updateLocation(locationData!);
    }
  }

  void _showCreateTagBottomSheet(
      BuildContext context, LocationData locationData) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return CreateTagPage(locationData: locationData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Padding(
      padding: const EdgeInsets.fromLTRB(75, 32, 75, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            icon: const Icon(
              Icons.pin_drop,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              'Tag Current Location',
              style: textStyleforNewTag,
            ),
            onPressed: () {
              getCurrentLocation();
            },
            style: buttonStyleforNewTag,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Tag Other Location',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Track New Route',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(mapStateProvider.notifier).clearLocation();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (_isGettingLocation) {
      previewContent = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Getting Current Location...'),
          ],
        ),
      );
    }

    return previewContent;
  }
}
