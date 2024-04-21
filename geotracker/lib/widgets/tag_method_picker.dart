import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/location_picker.dart';
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
    fixedSize: MaterialStateProperty.all<Size>(const Size(200, 30)),
    backgroundColor: MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 81, 7, 120),
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
      padding: const EdgeInsets.fromLTRB(95, 32, 95, 16),
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
          TextButton.icon(
            icon: const Icon(
              Icons.share_location,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(pickerStateProvider.notifier).startPicking();
            },
            style: buttonStyleforNewTag,
            label: Text(
              'Tag Other Location',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.route,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
            style: buttonStyleforNewTag,
            label: Text(
              'Route (developing)',
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
