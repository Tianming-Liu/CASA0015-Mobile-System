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
      body: Stack(
        children: [Image.file(geoTag.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity,)],
      )
    );
  }
}
