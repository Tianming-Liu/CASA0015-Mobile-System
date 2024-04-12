import 'package:firebase_auth/firebase_auth.dart';
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

  void _addNewGeoTag(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => NewGeoTagBottom(mainContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Records',
        ),
        actions: [
          // IconButton(onPressed: _addNewGeoTag, icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
                top: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
                left: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
                right: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
              ),
            ),
            height: 400,
            width: 350,
            child: const MapCanvas(),
          ),
          IconButton(
            onPressed: () => _addNewGeoTag(context),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: GeoTagList(geoTags: _storedTagPage),
          ),
        ],
      ),
    );
  }
}
