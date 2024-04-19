import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geotracker/style/custom_text_style.dart';

class PreviewMap extends StatefulWidget {
  const PreviewMap({super.key, required this.location});

  final LocationData location;

  @override
  State<PreviewMap> createState() => _PreviewMapState();
}

class _PreviewMapState extends State<PreviewMap> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Preview Map',
            style: CustomTextStyle.bigBoldBlackText,
          ),
        ),
        body: Center(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.latitude!, widget.location.longitude!),
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('Apple_California'),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(
                    widget.location.latitude!, widget.location.longitude!),
              )
            },
          ),
        ));
  }
}
