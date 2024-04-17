import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({super.key, required this.geoTag});

  final GeoTag geoTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          geoTag.category.toString(),
        ),
      ),
      body: Center(
        child: Text(
          geoTag.category.toString(),
        ),
      ),
    );
  }
}
