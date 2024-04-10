import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// Load Customized Map Style
import 'package:geotracker/models/map_style.dart';

class MapCanvas extends StatefulWidget {
  const MapCanvas({super.key});

  @override
  State<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends State<MapCanvas> {
  late GoogleMapController mapController;

  final mapStyle = MapStyle();

  // final LatLng _center = const LatLng(51.506734, 0.037341);
  final LatLng _uclEastCoord = const LatLng(51.537928, -0.011617);

  LocationData? currentLocation;

  List<LatLng> polylineCoords = [];

  void getCurrentLocation() async {
    Location location = Location();

    var locationData = await location.getLocation();
    setState(() {
      currentLocation = locationData;
    });

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      polylineCoords
          .add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 13,
          ),
        ),
      );
      setState(() {});
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyle.silver);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? const Center(child: Text('Loading'))
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 12,
            ),
            polylines: {
              Polyline(
                polylineId: const PolylineId('Route'),
                points: polylineCoords,
              ),
            },
            markers: {
              Marker(
                markerId: const MarkerId('90032399'),
                icon: BitmapDescriptor.defaultMarker,
                position: _uclEastCoord,
              ),
              Marker(
                markerId: const MarkerId('Apple_California'),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
              )
            },
          );
  }
}
