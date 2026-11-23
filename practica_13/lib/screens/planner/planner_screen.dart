import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/activity_model.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  OutdoorActivity _selectedActivity = OutdoorActivity.presets.first;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weather = context.watch<WeatherProvider>();
    final points = weather.plannerForecast;

    final safeSlots = points.where((p) => p.uvIndex <= 6.0).toList();
    final bestWindow = safeSlots.isNotEmpty
        ? 'Franjas óptimas (< 6 UV): ${safeSlots.map((e) => '${e.hour}:00').join(', ')}'
        : 'Todas las horas diurnas presentan radiación alta; prioriza antes de las 09:00 o después de las 16:00.';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Planificador de Actividad al Aire Libre',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                DropdownButtonFormField<OutdoorActivity>(
                  initialValue: _selectedActivity,
                  decoration: const InputDecoration(
                    labelText: 'Actividad',
                    border: OutlineInputBorder(),
                  ),
                  items: OutdoorActivity.presets
                      .map((a) => DropdownMenuItem(value: a, child: Text('${a.name} (${a.durationHours}h)')))
                      .toList(),
                  onChanged: (a) {
                    if (a != null) setState(() => _selectedActivity = a);
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 6)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      await weather.loadPlannerForDate(settings.selectedDistrict, picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(bestWindow, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...points.map((p) {
          final isSafe = p.uvIndex <= 6.0;
          return Card(
            child: ListTile(
              leading: Icon(
                isSafe ? Icons.check_circle : Icons.warning_amber_rounded,
                color: isSafe ? Colors.green : Colors.deepOrange,
              ),
              title: Text('${p.hour.toString().padLeft(2, '0')}:00 hrs — Índice UV ${p.uvIndex.toStringAsFixed(1)}'),
              subtitle: Text('Temperatura estimada: ${p.temperature.toStringAsFixed(1)} °C'),
              trailing: Text(
                isSafe ? 'RECOMENDADO' : 'ALTA RAD.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSafe ? Colors.green.shade800 : Colors.red.shade700,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}