import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/style/map_style.dart';
// StateNotifier that holds the map style
class MapStyleStateNotifier extends StateNotifier<String> {
  MapStyleStateNotifier() : super(MapStyle().silver);

  String getMapStyle(String style) {
    switch (style) {
      case 'light-grey':
        return MapStyle().silver;
      case 'light-green':
        return MapStyle().lightGreen;
      case 'dark-blue':
        return MapStyle().darkDefault;
      default:
        return MapStyle().silver;
    }
  }

  void setMapStyle(String newStyle) {
    print('Setting map style to $newStyle');
    state = getMapStyle(newStyle);
  }
}

// Provider for the map style
final mapStyleProvider = StateNotifierProvider<MapStyleStateNotifier, String>((ref) {
  return MapStyleStateNotifier();
});