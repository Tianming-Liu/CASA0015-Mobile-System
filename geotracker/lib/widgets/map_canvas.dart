import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// Load Customized Map Style

class MapCanvas extends StatefulWidget {
  final String mapStyle;
  const MapCanvas({super.key, required this.mapStyle});
  @override
  State<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends State<MapCanvas> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late GoogleMapController mapController;

  // final LatLng _center = const LatLng(51.506734, 0.037341);
  // final LatLng _uclEastCoord = const LatLng(51.537928, -0.011617);

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

    // location.onLocationChanged.listen((newLoc) {
    //   currentLocation = newLoc;
    //   polylineCoords
    //       .add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
    //   mapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target:
    //             LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    //         // zoom: 13,
    //       ),
    //     ),
    //   );
    //   setState(() {});
    // });
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

  // void _onGetCenter() async {
  //   LatLng center = await mapController.get
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return currentLocation == null
        ? const Center(child: Text('Loading'))
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 13,
            ),
            // polylines: {
            //   Polyline(
            //     polylineId: const PolylineId('Route'),
            //     points: polylineCoords,
            //   ),
            // },
            // markers: {
            //   Marker(
            //     markerId: const MarkerId('90032399'),
            //     icon: BitmapDescriptor.defaultMarker,
            //     position: _uclEastCoord,
            //   ),
            //   Marker(
            //     markerId: const MarkerId('Apple_California'),
            //     icon: BitmapDescriptor.defaultMarker,
            //     position: LatLng(
            //         currentLocation!.latitude!, currentLocation!.longitude!),
            //   )
            // },
          );
  }
}
