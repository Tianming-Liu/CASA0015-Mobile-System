import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:geotracker/screens/record_detail.dart';
import 'package:geotracker/style/custom_text_style.dart';
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
      // itemBuilder: (ctx, index) => GeoTagItem(geoTags[index]),
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: FileImage(geoTags[index].image),
        ),
        title: Text(
          geoTags[index].decodedAddress.substring(0, geoTags[index].decodedAddress.length - 11),
          style: CustomTextStyle.mediumBoldBlackText,
        ),
        subtitle: Text(
          geoTags[index].time.toString().substring(0,19),
          style: CustomTextStyle.smallBoldGreyText,
        ),
        trailing: geoTags[index].categoryIcon,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => RecordDetailPage(
                geoTag: geoTags[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
