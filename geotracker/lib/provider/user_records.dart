import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:geotracker/models/geotag.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, category TEXT, tagType TEXT, time TEXT, info TEXT, lat REAL, lng REAL, address TEXT, image TEXT);');
    },
    version: 1,
  );
  return db;
}

class UserRecordNotifier extends StateNotifier<List<GeoTag>> {
  UserRecordNotifier() : super(const []);

  TagType tagTypeFromString<TagType>(Iterable<TagType> values, String value) {
    var enumValue = value.split('.').last;
    return values.firstWhere((type) => type.toString().split('.').last == enumValue,
        orElse: () =>
            throw Exception("string conversion tp tagType failed,values:$values, value:$value"));
  }

  Category catogoryFromString<Category>(Iterable<Category> values, String value) {
    var enumValue = value.split('.').last;
    return values.firstWhere((type) => type.toString().split('.').last == enumValue,
        orElse: () =>
            throw Exception("string conversion to category failed,values:$values, value:$value"));
  }

  Future<void> loadRecords() async {
    // ignore: avoid_print
    print('begin loadRecords');
    final db = await _getDataBase();
    final data = await db.query('user_places');
    print('data query success $data');
    try {
      final records = data.map((row) {
        return GeoTag(
          id: row['id'] as String,
          category: catogoryFromString(Category.values,row['category'] as String),
          tagType: tagTypeFromString(TagType.values,row['tagType'] as String),
          time: DateTime.parse(row['time'] as String),
          info: row['info'] as String,
          location: LocationData.fromMap({
            'latitude': (row['lat'] as num).toDouble(),
            'longitude': (row['lng'] as num).toDouble(),
          }),
          decodedAddress: row['address'] as String,
          image: File(row['image'] as String)
        );
      }).toList();
      state = records;
      print('end loadRecords, records: ${records.length}');
    } catch (e) {
      print('Error processing data: $e');
    }
  }

  void addPlaceRecord(
      String id,
      Category category,
      TagType tagType,
      DateTime time,
      String info,
      LocationData location,
      String decodedAddress,
      File image) async {
    // This is the root directory for all the following operations
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // Get the temporary path of the image file
    final fileName = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final record = GeoTag(
      id: id,
      category: category,
      tagType: tagType,
      time: time,
      info: info,
      location: location,
      decodedAddress: decodedAddress,
      image: copiedImage,
    );

    final db = await _getDataBase();

    db.insert(
      'user_places',
      {
        'id': record.id,
        'category': record.category.toString(),
        'tagType': record.tagType.toString(),
        'time': record.time.toIso8601String(),
        'info': record.info,
        'lat': record.location.latitude,
        'lng': record.location.longitude,
        'address': record.decodedAddress,
        'image': record.image.path,
      },
    );

    state = [record, ...state];
    // ignore: avoid_print
    print('addPlaceRecord success');
  }
}

final userRecordProvider =
    StateNotifierProvider<UserRecordNotifier, List<GeoTag>>(
  (ref) => UserRecordNotifier(),
);
