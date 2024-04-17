import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/style/map_style.dart';

class UserMapStyleNotifier extends StateNotifier<String> {
  UserMapStyleNotifier() : super(MapStyle().silver);
  void changeMapStyle(String style) {
    state = style;
  }
}