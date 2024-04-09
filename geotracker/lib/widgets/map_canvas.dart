import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyle.silver);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _uclEastCoord,
        zoom: 12,
      ),
      // markers: {
      //   Marker(
      //     markerId: const MarkerId('90032399'),
      //     icon: BitmapDescriptor.defaultMarker,
      //     position: _uclEastCoord,
      //   ),
      // },
    );
  }
}
