import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final Map<String, Weather> _cache = {};

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  String _errorType = ''; // 'network', 'not_found', 'unauthorized', 'general'
  String _lastCity = '';

  Future<void> _fetchWeather(String city) async {
    final query = city.trim();
    if (query.isEmpty) return;

    final keyNormalized = query.toLowerCase();

    // 1. Verificar si está en memoria (Caché de 5 min)
    if (_cache.containsKey(keyNormalized)) {
      setState(() {
        _weather = _cache[keyNormalized];
        _isLoading = false;
        _errorMessage = null;
        _errorType = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorType = '';
      _lastCity = query;
    });

    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(query)}&units=metric&lang=es&appid=$apiKey',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = Weather.fromJson(data);
        _cache[keyNormalized] = weather;

        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
          _weather = null;
          _errorType = 'not_found';
          _errorMessage = 'No se encontró la ciudad "$query". Revisa el nombre.';
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
          _weather = null;
          _errorType = 'unauthorized';
          _errorMessage = 'API Key inválida o no activada aún por OpenWeatherMap.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _weather = null;
          _errorType = 'general';
          _errorMessage = 'Error del servidor (Código ${response.statusCode}).';
        });
      }
    } on SocketException {
      setState(() {
        _isLoading = false;
        _weather = null;
        _errorType = 'network';
        _errorMessage = 'Sin conexión a Internet. Verifica tus datos o Wi-Fi.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weather = null;
        _errorType = 'general';
        _errorMessage = 'Error inesperado: $e';
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 1: App Clima'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Ingresa una ciudad (ej. Cusco, Lima)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _fetchWeather(_cityController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
              ),
              onSubmitted: _fetchWeather,
            ),
            const SizedBox(height: 24),

            if (_isLoading) ...[
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Consultando OpenWeatherMap...'),
            ],

            if (!_isLoading && _errorMessage != null)
              _buildErrorCard(),

            if (!_isLoading && _weather != null)
              _buildWeatherCard(_weather!),

            if (!_isLoading && _errorMessage == null && _weather == null) ...[
              const SizedBox(height: 48),
              Icon(Icons.cloud_outlined, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Ingresa una ciudad para ver el clima.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weather.description.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                  width: 70,
                  height: 70,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.wb_sunny,
                    size: 48,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(Icons.thermostat, 'Temperatura', '${weather.temperature.toStringAsFixed(1)} °C', Colors.orange),
                _buildMetric(Icons.device_thermostat, 'Sensación', '${weather.feelsLike.toStringAsFixed(1)} °C', Colors.deepOrange),
                _buildMetric(Icons.water_drop, 'Humedad', '${weather.humidity} %', Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, color: Colors.green.shade700, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Caché en memoria activa (5 min)',
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildErrorCard() {
    IconData icon = Icons.error_outline;
    Color color = Colors.redAccent;
    String title = 'Ocurrió un error';

    if (_errorType == 'network') {
      icon = Icons.wifi_off_rounded;
      title = 'Sin Conexión';
      color = Colors.red.shade700;
    } else if (_errorType == 'not_found') {
      icon = Icons.location_off_rounded;
      title = 'Ciudad no Encontrada';
      color = Colors.orange.shade800;
    } else if (_errorType == 'unauthorized') {
      icon = Icons.key_off_rounded;
      title = 'Error de Clave API (401)';
      color = Colors.redAccent;
    }

    return Card(
      elevation: 2,
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => _fetchWeather(_lastCity),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}