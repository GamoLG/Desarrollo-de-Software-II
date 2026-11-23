import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/district_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherReport> fetchDistrictWeather(
      DistrictModel district, {
        DateTime? targetDate,
      }) async {
    final date = targetDate ?? DateTime.now();
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=${district.latitude}'
          '&longitude=${district.longitude}'
          '&current=temperature_2m,relative_humidity_2m,cloud_cover,wind_speed_10m,uv_index'
          '&hourly=temperature_2m,uv_index'
          '&start_date=$dateStr'
          '&end_date=$dateStr'
          '&timezone=America%2FLima',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>;
    final hourly = data['hourly'] as Map<String, dynamic>;

    final times = (hourly['time'] as List<dynamic>).cast<String>();
    final uvList = hourly['uv_index'] as List<dynamic>;
    final tempList = hourly['temperature_2m'] as List<dynamic>;

    final points = <HourlyUvPoint>[];
    for (int i = 0; i < times.length; i++) {
      final parsedTime = DateTime.tryParse(times[i]);
      final h = parsedTime?.hour ?? i;
      if (h >= 6 && h <= 18) {
        points.add(
          HourlyUvPoint(
            hour: h,
            uvIndex: ((uvList[i] as num?)?.toDouble() ?? 0.0),
            temperature: ((tempList[i] as num?)?.toDouble() ?? 16.0),
          ),
        );
      }
    }

    // Ajuste altitudinal andino (~4% por cada 300 m sobre 3000 m) si la API reporta 0 en horario diurno
    final rawUv = (current['uv_index'] as num?)?.toDouble() ?? 0.0;
    final altitudeFactor = 1.0 + ((district.altitudeMeters - 3000).clamp(0, 1500) / 3000.0) * 0.25;

    return WeatherReport(
      districtId: district.id,
      currentUv: double.parse((rawUv * altitudeFactor).toStringAsFixed(1)),
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 17.5,
      humidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 48,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 12.0,
      cloudCover: (current['cloud_cover'] as num?)?.toInt() ?? 30,
      updatedAt: DateTime.now(),
      isFromCache: false,
      hourlyForecast: points,
    );
  }
}