import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:io';

const uuid = Uuid();

final formatter = DateFormat.yMd().add_jm();

enum Category { leisure, work, cycling, photo }

enum TagType { place, route }

const categoryIcons = {
  Category.photo: Icons.videocam,
  Category.cycling: Icons.directions_bike,
  Category.leisure: Icons.attractions,
  Category.work: Icons.work,
};

class GeoTag {
  GeoTag(
      {required this.id,
      required this.category,
      required this.tagType,
      required this.time,
      required this.info,
      required this.aqi,
      required this.location,
      required this.decodedAddress,
      required this.image});
  // unique id for each geotag
  final String id;
  // the category users choose when creating
  final Category category;
  // differentiate the place tag and route tag
  final TagType tagType;
  // record the creating time of each tag
  final DateTime time;
  final String info;
  final String aqi;
  final LocationData location;
  final String decodedAddress;
  final File image;

  String get formattedDate {
    return formatter.format(time);
  }

  Icon get categoryIcon {
    return Icon(categoryIcons[category]);
  }
}
