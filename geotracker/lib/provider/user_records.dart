// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geotracker/models/geotag.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, uid TEXT, category TEXT, tagType TEXT, time TEXT, info TEXT, aqi TEXT, lat REAL, lng REAL, address TEXT, image TEXT);');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute('ALTER TABLE user_places ADD COLUMN uid TEXT');
      }
      if (oldVersion < 3) {
        db.execute('ALTER TABLE user_places ADD COLUMN aqi TEXT');
      }
    },
    version: 3, // Update the version number to 3
  );
}

class UserRecordNotifier extends StateNotifier<List<GeoTag>> {
  UserRecordNotifier() : super(const []);

  TagType tagTypeFromString<TagType>(Iterable<TagType> values, String value) {
    var enumValue = value.split('.').last;
    return values.firstWhere(
        (type) => type.toString().split('.').last == enumValue,
        orElse: () => throw Exception(
            "string conversion tp tagType failed,values:$values, value:$value"));
  }

  Category catogoryFromString<Category>(
      Iterable<Category> values, String value) {
    var enumValue = value.split('.').last;
    return values.firstWhere(
        (type) => type.toString().split('.').last == enumValue,
        orElse: () => throw Exception(
            "string conversion to category failed,values:$values, value:$value"));
  }

  Future<void> loadRecords() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('begin loadRecords');
    if (user == null) {
      return;
    }
    final db = await _getDataBase();
    final data = await db.query(
      'user_places',
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
    print('data query success $data');
    try {
      final records = data.map((row) {
        return GeoTag(
            id: row['id'] as String,
            category:
                catogoryFromString(Category.values, row['category'] as String),
            tagType:
                tagTypeFromString(TagType.values, row['tagType'] as String),
            time: DateTime.parse(row['time'] as String),
            info: row['info'] as String,
            aqi: row['aqi'] as String,
            location: LocationData.fromMap({
              'latitude': (row['lat'] as num).toDouble(),
              'longitude': (row['lng'] as num).toDouble(),
            }),
            decodedAddress: row['address'] as String,
            image: File(row['image'] as String));
      }).toList();
      state = records;
      print('end loadRecords, records: ${records.length}');
    } catch (e) {
      print('Error processing data: $e');
    }
  }

  Future<void> syncDataFromCloud() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final db = await _getDataBase();
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // Get all the tag data from the cloud
    final snapshot = await firestore
        .collection('locationData')
        .doc(user.uid)
        .collection('tag')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final localId = data['id'] as String;

      // Check if the record already exists in the local database
      List<Map<String, dynamic>> existingRecords = await db.query(
        'user_places',
        where: 'id = ?',
        whereArgs: [localId],
      );

      if (existingRecords.isEmpty) {
        // get the image from the cloud storage
        final imageUrl = data['image_url'] as String;
        final imageRef = storage.refFromURL(imageUrl);
        print('image download sucessful: $imageUrl');
        final File localFile = File('${appDir.path}/$localId.jpg');
        await imageRef.writeToFile(localFile);

        // 添加到本地数据库
        await db.insert('user_places', {
          'id': localId,
          'uid': user.uid,
          'category': data['category'],
          'tagType': 'TagType.place',
          'time': data['time'],
          'info': data['note'],
          'aqi': data['aqi'],
          'lat': extractLatitude(data['location']),
          'lng': extractLongitude(data['location']),
          'address': data['address'],
          'image': localFile.path,
        });

        // 更新状态
        state = [
          GeoTag(
            id: localId,
            category:
                catogoryFromString(Category.values, data['category'] as String),
            tagType: TagType.place,
            time: DateTime.parse(data['time'] as String),
            info: data['note'] as String,
            aqi: data['aqi'] as String,
            location: LocationData.fromMap({
              'latitude': extractLatitude(data['location']),
              'longitude': extractLongitude(data['location']),
            }),
            decodedAddress: data['address'] as String,
            image: localFile,
          ),
          ...state,
        ];
      }
    }
    print('Sync complete');
  }

  double extractLatitude(String location) {
    return double.parse(location.split(',')[0].split(':')[1]);
  }

  double extractLongitude(String location) {
    return double.parse(location.split(',')[1].split(':')[1]);
  }

  void addPlaceRecord(
      String userId,
      String id,
      Category category,
      TagType tagType,
      DateTime time,
      String info,
      String aqi,
      LocationData location,
      String decodedAddress,
      File image) async {
    print(userId);
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
      aqi: aqi,
      location: location,
      decodedAddress: decodedAddress,
      image: copiedImage,
    );

    final db = await _getDataBase();

    print('start insert record: $record, userId: $userId');

    db.insert(
      'user_places',
      {
        'id': record.id,
        'uid': userId,
        'category': record.category.toString(),
        'tagType': record.tagType.toString(),
        'time': record.time.toIso8601String(),
        'info': record.info,
        'aqi': record.aqi,
        'lat': record.location.latitude,
        'lng': record.location.longitude,
        'address': record.decodedAddress,
        'image': record.image.path,
      },
    );

    state = [record, ...state];
    print('addPlaceRecord success');
  }

  void clearTempRecords() {
    state = [];
  }

  Future<void> clearUserRecords() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final db = await _getDataBase();
    await db.delete(
      'user_places',
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
    state = [];
    print('All records for user ${user.uid} have been cleared');
  }

}

final userRecordProvider =
    StateNotifierProvider<UserRecordNotifier, List<GeoTag>>(
  (ref) => UserRecordNotifier(),
);
