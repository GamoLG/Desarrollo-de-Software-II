import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weather = context.watch<WeatherProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: SwitchListTile(
            title: const Text('Alertas automáticas de radiación UV',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Notifica localmente cuando Cusco supere tu umbral UV'),
            value: settings.alertsEnabled,
            onChanged: (v) => settings.setAlertsEnabled(v),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Umbral de alerta: Índice UV ${settings.uvThreshold.toStringAsFixed(1)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Slider(
                  min: 3,
                  max: 13,
                  divisions: 10,
                  value: settings.uvThreshold,
                  label: settings.uvThreshold.toStringAsFixed(1),
                  onChanged: settings.alertsEnabled ? (v) => settings.setUvThreshold(v) : null,
                ),
                const Divider(),
                const Text('Recordatorio de reaplicación de protector solar',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 60, label: Text('60 min')),
                    ButtonSegment(value: 90, label: Text('90 min')),
                    ButtonSegment(value: 120, label: Text('120 min')),
                  ],
                  selected: {settings.reminderMinutes},
                  onSelectionChanged: (s) => settings.setReminderMinutes(s.first),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () async {
            final uv = weather.currentReport?.currentUv ?? 11.4;
            await weather.triggerTestAlert(settings.selectedDistrict.name, uv);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificación local de prueba enviada.')),
              );
            }
          },
          icon: const Icon(Icons.notifications_active),
          label: const Text('Probar notificación UV ahora'),
        ),
      ],
    );
  }
}