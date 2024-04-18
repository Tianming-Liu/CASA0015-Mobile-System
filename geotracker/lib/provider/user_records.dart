import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:geotracker/models/geotag.dart';

class UserRecordNotifier extends StateNotifier<List<GeoTag>> {
  UserRecordNotifier() : super(const []);
  void addPlaceRecord(String id,Category category, TagType tagType, DateTime time, String info,LocationData location,String decodedAddress, File image) {
    final record = GeoTag(
      id: id,
      category: category,
      tagType: tagType,
      time: time,
      info: info,
      location: location,
      decodedAddress: decodedAddress,
      image: image,
    );
    state = [record, ...state];
    // ignore: avoid_print
    print('addPlaceRecord success');
  }
}

final userRecordProvider = StateNotifierProvider<UserRecordNotifier, List<GeoTag>>(
  (ref) => UserRecordNotifier(),
);
