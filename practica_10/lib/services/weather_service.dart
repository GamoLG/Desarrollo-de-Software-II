import 'dart:async' hide TimeoutException;
import 'dart:async' as async_pkg show TimeoutException;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../core/exceptions/api_exceptions.dart';
import '../models/weather.dart';

class _CacheEntry {
  final Weather weather;
  final DateTime timestamp;

  _CacheEntry(this.weather, this.timestamp);

  bool get isValid =>
      DateTime.now().difference(timestamp) < const Duration(minutes: 5);
}

class WeatherService {
  final http.Client _client;
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  final Map<String, _CacheEntry> _cache = {};

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<Weather> getWeather(String city) async {
    final normalizedCity = city.trim().toLowerCase();

    if (_cache.containsKey(normalizedCity)) {
      final entry = _cache[normalizedCity]!;
      if (entry.isValid) {
        return entry.weather;
      } else {
        _cache.remove(normalizedCity);
      }
    }

    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw const ApiKeyException();
    }

    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeComponent(city.trim())}&appid=$apiKey&units=metric&lang=es',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 200:
          try {
            final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
            final weather = Weather.fromJson(jsonMap);
            _cache[normalizedCity] = _CacheEntry(weather, DateTime.now());
            return weather;
          } catch (e) {
            throw ParseException(e.toString());
          }
        case 401:
          throw const ApiKeyException();
        case 404:
          throw CityNotFoundException(city);
        default:
          throw ServerException(response.statusCode);
      }
    } on SocketException {
      throw const NetworkException();
    } on async_pkg.TimeoutException {
      throw const TimeoutException();
    }
  }

  void clearCache() => _cache.clear();

  void dispose() => _client.close();
}