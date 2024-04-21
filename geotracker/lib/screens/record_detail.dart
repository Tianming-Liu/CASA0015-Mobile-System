import 'package:flutter/material.dart';
import 'package:geotracker/models/geotag.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geotracker/screens/preview_map.dart';
import 'package:geotracker/style/custom_text_style.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class RecordDetailPage extends StatefulWidget {
  final GeoTag geoTag;
  const RecordDetailPage({super.key, required this.geoTag});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late AqiData aqiData;

  @override
  void initState() {
    super.initState();
    aqiSpots = parseAqiData(widget.geoTag.aqi);
    aqiData = parseAqi(widget.geoTag.aqi);
  }

  String get locationImage {
    final lat = widget.geoTag.location.latitude;
    final lng = widget.geoTag.location.longitude;
    String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=400x600&maptype=satellite&markers=color:red%7C$lat,$lng&key=$apiKey';
  }

  List<FlSpot> parseAqiData(String jsonData) {
    final data = json.decode(jsonData);
    List<FlSpot> spots = [];
    var hourIndex = 0.0;
    for (var hour in data['hoursInfo']) {
      final aqi = hour['indexes'][0]['aqi'].toDouble();
      spots.add(FlSpot(hourIndex, aqi));
      hourIndex += 1.0;
    }
    return spots;
  }

  late List<FlSpot> aqiSpots;

  AqiData parseAqi(String jsonData) {
    final data = json.decode(jsonData);
    List<FlSpot> spots = [];
    List<String> times = [];
    var hourIndex = 0.0;

    for (var hour in data['hoursInfo']) {
      final dateTimeStr = hour['dateTime'] as String;
      final dateTime = DateTime.parse(dateTimeStr);
      final formattedTime =
          dateTime.toUtc().toString(); // Format time as hour:minute
      final aqi = double.parse(hour['indexes'][0]['aqi'].toString());

      spots.add(FlSpot(hourIndex, aqi));
      times.add(formattedTime);
      hourIndex += 1.0;
    }
    return AqiData(spots: spots, times: times);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 2,
              getTitlesWidget: (value, meta) {
                var index = value.toInt();
                var text =
                    index < aqiData.times.length ? '$index H Before' : '';
                return RotatedBox(
                  quarterTurns: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      text,
                      style: CustomTextStyle.tinyBoldGreyText,
                    ),
                  ),
                );
              }),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: aqiData.spots,
          isCurved: true,
          color: const Color.fromARGB(255, 81, 7, 120),
          barWidth: 2,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: const Color.fromARGB(255, 81, 7, 120).withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(value.toStringAsFixed(0),
          style: CustomTextStyle.tinyBoldGreyText, textAlign: TextAlign.right),
    );
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
            height: 10,
          ),
          Stack(
            children: [
              Image.file(
                widget.geoTag.image,
                fit: BoxFit.cover,
                width: 400,
                height: 400,
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
          Column(
            children: [
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
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.geoTag.info,
                              style: CustomTextStyle.mediumBoldBlackText,
                            ),
                          ),
                        ),
                        // Text(
                        //   widget.geoTag.info,
                        //   style: CustomTextStyle.mediumBoldBlackText,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
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
                      const SizedBox(height: 10),
                      Text(widget.geoTag.time.toString().substring(0, 19),
                          style: CustomTextStyle.mediumBoldBlackText),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              Text('Air Quality Index (AQI) in the last 24 hours:',
                  style: CustomTextStyle.mediumBoldGreyText),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(right: 30),
                height: 130,
                width: 400,
                child: LineChart(mainData()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AqiData {
  List<FlSpot> spots;
  List<String> times;

  AqiData({required this.spots, required this.times});
}
