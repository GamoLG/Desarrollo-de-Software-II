import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/uv_model.dart';
import '../../providers/weather_provider.dart';

class DistrictsScreen extends StatefulWidget {
  const DistrictsScreen({super.key});

  @override
  State<DistrictsScreen> createState() => _DistrictsScreenState();
}

class _DistrictsScreenState extends State<DistrictsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadAllDistricts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Comparador de Sectores — Cusco',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              onPressed: weather.isLoading ? null : () => weather.loadAllDistricts(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...AppConstants.cuscoDistricts.map((district) {
          final report = weather.districtReports[district.id];
          final uv = report?.currentUv ?? 0.0;
          final color = AppColors.uvColor(uv);
          final info = UvClassification.fromIndex(uv);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Text(
                  report != null ? uv.toStringAsFixed(1) : '--',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              title: Text(district.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                report != null
                    ? '${district.altitudeMeters} m · ${report.temperature.toStringAsFixed(1)} °C · Humedad ${report.humidity}%'
                    : '${district.altitudeMeters} m · Cargando datos...',
              ),
              trailing: Chip(
                label: Text(info.level, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }),
      ],
    );
  }
}