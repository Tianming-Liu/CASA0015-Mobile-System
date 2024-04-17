import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:google_fonts/google_fonts.dart';

class GeoTagItem extends StatelessWidget {
  const GeoTagItem(this.geoTag, {super.key});

  final GeoTag geoTag;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Text(
              geoTag.category.toString().split('.').last.toUpperCase(),
              style: GoogleFonts.roboto(),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(geoTag.info),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      categoryIcons[geoTag.category],
                    ),
                    Text(
                      geoTag.formattedDate,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
