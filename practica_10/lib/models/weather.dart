class Weather {
  final int id;
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final String description;
  final String iconCode;

  const Weather({
    required this.id,
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.iconCode,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherInfo = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final mainInfo = json['main'] as Map<String, dynamic>? ?? {};

    return Weather(
      id: json['id'] as int? ?? 0,
      cityName: json['name'] as String? ?? 'Desconocida',
      temperature: (mainInfo['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (mainInfo['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (mainInfo['humidity'] as num?)?.toInt() ?? 0,
      description: weatherInfo['description'] as String? ?? 'Despejado',
      iconCode: weatherInfo['icon'] as String? ?? '01d',
    );
  }
}