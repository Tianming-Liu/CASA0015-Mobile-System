import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

const uuid = Uuid();

final formatter = DateFormat.yMd().add_jm();

enum Category { food, travel, leisure, work, cycling, running }

enum TagType { place, route }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.house,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class GeoTag {
  GeoTag(
      {required this.category,
      required this.tagType,
      required this.time,
      required this.info,
      required this.image})
      : id = uuid.v4();
  // unique id for each geotag
  final String id;
  // the category users choose when creating
  final Category category;
  // differentiate the place tag and route tag
  final TagType tagType;
  // record the creating time of each tag
  final DateTime time;
  final String info;

  final File image;

  String get formattedDate {
    return formatter.format(time);
  }
}
