import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_10/core/exceptions/api_exceptions.dart';
import 'package:practica_10/services/weather_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=test_api_key');
  });

  group('Ejercicio 1: WeatherService Tests', () {
    test('getWeather retorna objeto Weather cuando statusCode es 200', () async {
      final mockData = jsonEncode({
        'id': 3936456,
        'name': 'Lima',
        'main': {'temp': 21.5, 'feels_like': 22.0, 'humidity': 78},
        'weather': [
          {'description': 'cielo claro', 'icon': '01d'}
        ],
      });

      final mockClient = MockClient((request) async {
        return http.Response(mockData, 200);
      });

      final service = WeatherService(client: mockClient);
      final weather = await service.getWeather('Lima');

      expect(weather.cityName, 'Lima');
      expect(weather.temperature, 21.5);
      expect(weather.humidity, 78);
    });

    test('Lanza CityNotFoundException cuando statusCode es 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = WeatherService(client: mockClient);
      expect(
            () => service.getWeather('CiudadInexistenteXYZ'),
        throwsA(isA<CityNotFoundException>()),
      );
    });

    test('Lanza ApiKeyException cuando statusCode es 401', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final service = WeatherService(client: mockClient);
      expect(
            () => service.getWeather('Cusco'),
        throwsA(isA<ApiKeyException>()),
      );
    });
  });
}