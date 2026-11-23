class HourlyUvPoint {
  final int hour;
  final double uvIndex;
  final double temperature;

  const HourlyUvPoint({
    required this.hour,
    required this.uvIndex,
    required this.temperature,
  });

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'uvIndex': uvIndex,
    'temperature': temperature,
  };

  factory HourlyUvPoint.fromJson(Map<String, dynamic> json) => HourlyUvPoint(
    hour: json['hour'] as int,
    uvIndex: (json['uvIndex'] as num).toDouble(),
    temperature: (json['temperature'] as num).toDouble(),
  );
}

class WeatherReport {
  final String districtId;
  final double currentUv;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int cloudCover;
  final DateTime updatedAt;
  final bool isFromCache;
  final List<HourlyUvPoint> hourlyForecast;

  const WeatherReport({
    required this.districtId,
    required this.currentUv,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.cloudCover,
    required this.updatedAt,
    required this.isFromCache,
    required this.hourlyForecast,
  });

  Map<String, dynamic> toJson() => {
    'districtId': districtId,
    'currentUv': currentUv,
    'temperature': temperature,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'cloudCover': cloudCover,
    'updatedAt': updatedAt.toIso8601String(),
    'hourlyForecast': hourlyForecast.map((e) => e.toJson()).toList(),
  };

  factory WeatherReport.fromJson(Map<String, dynamic> json, {bool cached = true}) {
    final list = (json['hourlyForecast'] as List<dynamic>)
        .map((e) => HourlyUvPoint.fromJson(e as Map<String, dynamic>))
        .toList();
    return WeatherReport(
      districtId: json['districtId'] as String,
      currentUv: (json['currentUv'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFromCache: cached,
      hourlyForecast: list,
    );
  }
}