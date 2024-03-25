import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:geotracker/widgets/geotag_list/geotag_item.dart';

class GeoTagList extends StatelessWidget {
  const GeoTagList({
    super.key,
    required this.geoTags,
  });

  final List<GeoTag> geoTags; 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: geoTags.length, 
      itemBuilder: (ctx, index) => GeoTagItem(geoTags[index]),
    );
  }
}
