import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../../widgets/forecast_chart.dart';
import '../../widgets/uv_gauge.dart';
import '../../widgets/weather_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weather = context.watch<WeatherProvider>();
    final report = weather.currentReport;

    return RefreshIndicator(
      onRefresh: () => weather.refreshDistrict(
        settings.selectedDistrict,
        alertsEnabled: settings.alertsEnabled,
        uvThreshold: settings.uvThreshold,
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField(
            initialValue: settings.selectedDistrict,
            decoration: const InputDecoration(
              labelText: 'Sector de Cusco',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            items: AppConstants.cuscoDistricts
                .map((d) => DropdownMenuItem(value: d, child: Text('${d.name} (${d.altitudeMeters} m)')))
                .toList(),
            onChanged: (d) async {
              if (d != null) {
                await settings.setDistrict(d);
                await weather.refreshDistrict(
                  d,
                  alertsEnabled: settings.alertsEnabled,
                  uvThreshold: settings.uvThreshold,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          if (weather.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Chip(
                avatar: const Icon(Icons.cloud_off, size: 18),
                label: Text(weather.errorMessage!, style: const TextStyle(fontSize: 12)),
              ),
            ),
          if (weather.isLoading && report == null)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (report != null) ...[
            UvGauge(
              uvIndex: report.currentUv,
              altitudeMeters: settings.selectedDistrict.altitudeMeters,
            ),
            const SizedBox(height: 12),
            WeatherCard(report: report),
            const SizedBox(height: 12),
            ForecastChart(points: report.hourlyForecast),
            const SizedBox(height: 8),
            Text(
              'Actualizado: ${DateFormat('dd/MM/yyyy HH:mm').format(report.updatedAt)}'
                  '${report.isFromCache ? ' · Caché local' : ' · Open-Meteo en vivo'}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}