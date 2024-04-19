import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geotracker/screens/preview_map.dart';
import 'package:geotracker/style/custom_text_style.dart';

class RecordDetailPage extends StatefulWidget {
  final GeoTag geoTag;
  const RecordDetailPage({super.key, required this.geoTag});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  String get locationImage {
    final lat = widget.geoTag.location.latitude;
    final lng = widget.geoTag.location.longitude;
    String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=400x600&maptype=satellite&markers=color:red%7C$lat,$lng&key=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.geoTag.decodedAddress
              .substring(0, widget.geoTag.decodedAddress.length - 4),
          style: CustomTextStyle.bigBoldBlackText,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Stack(
            children: [
              Image.file(
                widget.geoTag.image,
                fit: BoxFit.cover,
                width: 400,
                height: 500,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => PreviewMap(
                              location: widget.geoTag.location,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text(
                        widget.geoTag.decodedAddress,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.mediumBoldWhiteText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: CustomTextStyle.mediumBoldGreyText,
                    ),
                    const SizedBox(height: 16),
                    Text(widget.geoTag.info,
                        style: CustomTextStyle.mediumBoldBlackText),
                  ],
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time:',
                    style: CustomTextStyle.mediumBoldGreyText,
                  ),
                  const SizedBox(height: 16),
                  Text(widget.geoTag.time.toString().substring(0, 19),
                      style: CustomTextStyle.mediumBoldBlackText),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
