class AirQualityInfo {
  final DateTime dateTime;
  final List<IndexInfo> indexes;

  AirQualityInfo({required this.dateTime, required this.indexes});

  factory AirQualityInfo.fromJson(Map<String, dynamic> json) {
    var dateTime = DateTime.parse(json['dateTime']);
    var indexes = (json['indexes'] as List)
        .map((indexJson) => IndexInfo.fromJson(indexJson))
        .toList();
    return AirQualityInfo(dateTime: dateTime, indexes: indexes);
  }
}

class IndexInfo {
  final int aqi;
  final String category;
  final String dominantPollutant;

  IndexInfo({
    required this.aqi,
    required this.category,
    required this.dominantPollutant,
  });

  factory IndexInfo.fromJson(Map<String, dynamic> json) {
    return IndexInfo(
      aqi: json['aqi'],
      category: json['category'],
      dominantPollutant: json['dominantPollutant'],
    );
  }
}