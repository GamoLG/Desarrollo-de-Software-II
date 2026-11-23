import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherReport report;

  const WeatherCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _metric(Icons.thermostat, '${report.temperature.toStringAsFixed(1)} °C', 'Temp.'),
            _metric(Icons.water_drop_outlined, '${report.humidity}%', 'Humedad'),
            _metric(Icons.air, '${report.windSpeed.toStringAsFixed(1)} km/h', 'Viento'),
            _metric(Icons.cloud_outlined, '${report.cloudCover}%', 'Nubes'),
          ],
        ),
      ),
    );
  }

  Widget _metric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE65100)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}