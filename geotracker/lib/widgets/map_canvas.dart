import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/location_picker.dart';
import 'package:geotracker/provider/map_state.dart';
import 'package:geotracker/style/custom_text_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geotracker/widgets/create_geodata/create_tag.dart';
import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/provider/map_style.dart';
import 'package:geotracker/models/geotag.dart';

class MapCanvas extends ConsumerStatefulWidget {
  const MapCanvas({super.key});
  @override
  ConsumerState<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends ConsumerState<MapCanvas> {
  late GoogleMapController mapController;

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    var locationData = await location.getLocation();
    setState(() {
      currentLocation = locationData;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final initialStyle = ref.read(mapStyleProvider);
    mapController.setMapStyle(initialStyle);
  }

  late Future<void> _recordsFuture;

  Set<Marker> dataBaseMarkers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _recordsFuture = ref.read(userRecordProvider.notifier).loadRecords();
    // loadMarkers();
    _recordsFuture.then((_) {
      loadMarkers();
    });
  }

  BitmapDescriptor getMarkerIconByCategory(Category category) {
    switch (category) {
      case Category.leisure:
        return BitmapDescriptor.defaultMarkerWithHue(220);
      case Category.work:
        return BitmapDescriptor.defaultMarkerWithHue(290);
      case Category.cycling:
        return BitmapDescriptor.defaultMarkerWithHue(110);
      case Category.photo:
        return BitmapDescriptor.defaultMarkerWithHue(33);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void loadMarkers() async {
    final userRecords = ref.watch(userRecordProvider);
    setState(() {
      dataBaseMarkers = userRecords
          .map((record) => Marker(
                markerId: MarkerId(record.id),
                icon: getMarkerIconByCategory(record.category),
                position: LatLng(
                    record.location.latitude!, record.location.longitude!),
                infoWindow: InfoWindow(
                  title: record.info,
                  snippet: record.formattedDate,
                ),
              ))
          .toSet();
    });
  }

  Widget iconWithLabel(Category category, String label) {
    return Column(
      children: [
        Icon(
          Icons.location_on, // 使用简单的Material图标代替自定义图标
          color: markerColorByCategory(category),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Color markerColorByCategory(Category category) {
    switch (category) {
      case Category.leisure:
        return const Color.fromARGB(255, 0, 87, 255); // Azure
      case Category.work:
        return const Color.fromARGB(255, 134, 0, 160); // Blue
      case Category.cycling:
        return const Color.fromARGB(255, 27, 163, 0); // Green
      case Category.photo:
        return const Color.fromARGB(255, 255, 140, 0); // Red
      default:
        return Colors.grey; // Default
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

    loadMarkers();

    final isPicking =
        ref.watch(pickerStateProvider.select((state) => state.isPicking));

    ref.listen<String>(mapStyleProvider, (_, newStyle) {
      mapController.setMapStyle(newStyle);
      setState(() {});
    });

    return currentLocation == null
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 100, 100, 100),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Map Loading...', style: CustomTextStyle.mediumBoldGreyText),
            ],
          ))
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
                      markerId: const MarkerId('Picked Location'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(locationDataForDisplay.latitude!,
                          locationDataForDisplay.longitude!),
                    )
                  }
                : dataBaseMarkers,
          );
  }
}
