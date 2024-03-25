import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:geotracker/widgets/geotag_list/geotag_list.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('The Chart'),
        Expanded(
          child: GeoTagList(geoTags: _storedTagPage),
        ),
      ],
    );
  }
}
