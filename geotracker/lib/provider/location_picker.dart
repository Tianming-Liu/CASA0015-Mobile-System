import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickerState {
  final bool isPicking;
  final LatLng? pickedLocation;

  PickerState({this.isPicking = false, this.pickedLocation});

  PickerState copyWith({bool? isPicking, LatLng? pickedLocation}) {
    return PickerState(
      isPicking: isPicking ?? this.isPicking,
      pickedLocation: pickedLocation ?? this.pickedLocation,
    );
  }
}

class PickerStateNotifier extends StateNotifier<PickerState> {
  PickerStateNotifier() : super(PickerState());

  void startPicking() {
    state = state.copyWith(isPicking: true);
  }

  void stopPicking() {
    state = state.copyWith(isPicking: false);
  }

  void pickLocation(LatLng location) {
    state = state.copyWith(pickedLocation: location, isPicking: false);
  }
}

final pickerStateProvider = StateNotifierProvider<PickerStateNotifier, PickerState>((ref) {
  return PickerStateNotifier();
});