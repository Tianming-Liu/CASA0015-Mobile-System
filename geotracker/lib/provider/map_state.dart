import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

class MapStateNotifier extends StateNotifier<LocationData?> {
  MapStateNotifier() : super(null);

  void updateLocation(LocationData newLocation) {
    state = newLocation;
  }

  void clearLocation() {
    state = null;
  }
}

final mapStateProvider = StateNotifierProvider<MapStateNotifier, LocationData?>((ref) {
  return MapStateNotifier();
});