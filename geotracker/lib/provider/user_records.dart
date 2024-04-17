import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geotracker/models/geotag.dart';

class UserRecordNotifier extends StateNotifier<List<GeoTag>> {
  UserRecordNotifier() : super(const []);
  void addPlaceRecord(Category category, TagType tagType, DateTime time, String info, File image) {
    final record = GeoTag(
      category: category,
      tagType: tagType,
      time: time,
      info: info,
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
