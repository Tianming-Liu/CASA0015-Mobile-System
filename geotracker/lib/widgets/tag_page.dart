import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:geotracker/widgets/geotag_list/geotag_list.dart';
import 'package:geotracker/widgets/new_geotag.dart';

import 'package:geotracker/widgets/map_canvas.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final List<GeoTag> _storedTagPage = [
    GeoTag(
      time: DateTime.now(),
      info: 'First tag',
      category: Category.leisure,
      tagType: TagType.place,
    ),
    GeoTag(
      time: DateTime.now(),
      info: 'Second tag',
      category: Category.work,
      tagType: TagType.place,
    ),
  ];

  void _addNewGeoTag() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const NewGeoTag(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Records'),
        actions: [
          IconButton(onPressed: _addNewGeoTag, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 400,
            width: 350,
            child: MapCanvas(),
          ),
          Expanded(
            child: GeoTagList(geoTags: _storedTagPage),
          ),
        ],
      ),
    );
  }
}
