import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/location_picker.dart';
import 'package:geotracker/provider/map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geotracker/widgets/create_geodata/create_tag.dart';

class MapCanvas extends ConsumerStatefulWidget {
  final String mapStyle;
  const MapCanvas({super.key, required this.mapStyle});
  @override
  ConsumerState<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends ConsumerState<MapCanvas> {
  late GoogleMapController mapController;

  bool showMarker = false;

  Marker? centerMarker;

  LocationData? currentLocation;

  List<LatLng> polylineCoords = [];

  void getCurrentLocation() async {
    Location location = Location();

    var locationData = await location.getLocation();
    setState(() {
      currentLocation = locationData;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(widget.mapStyle);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MapCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mapStyle != widget.mapStyle) {
      mapController.setMapStyle(widget.mapStyle);
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

  void _handleTap(LatLng tapped) {
    print("Tapped location: ${tapped.latitude}, ${tapped.longitude}");
    ref.read(pickerStateProvider.notifier).pickLocation(tapped);
    Map<String, double> locationMap = {
      'latitude': tapped.latitude,
      'longitude': tapped.longitude,
      'accuracy': 0.0,
      'altitude': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0,
      'heading': 0.0,
      'time': DateTime.now().millisecondsSinceEpoch.toDouble(),
    };
    LocationData displayLocation = LocationData.fromMap(locationMap);
    
    ref.read(mapStateProvider.notifier).updateLocation(displayLocation);
    _showCreateTagBottomSheet(context, displayLocation);
  }

  @override
  Widget build(BuildContext context) {
    final locationDataForDisplay = ref.watch(mapStateProvider);

    final isPicking = ref.watch(pickerStateProvider.select((state) => state.isPicking));

    return currentLocation == null
        ? const Center(child: Text('Loading'))
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 13,
            ),
            onTap: isPicking ? _handleTap : null,
            markers: locationDataForDisplay != null
                ? {
                    Marker(
                      markerId: const MarkerId('Apple_California'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(locationDataForDisplay.latitude!,
                          locationDataForDisplay.longitude!),
                    )
                  }
                : {},
          );
  }
}
