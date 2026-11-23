import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/uv_model.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../../widgets/recommendation_card.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final report = context.watch<WeatherProvider>().currentReport;
    final uv = report?.currentUv ?? 10.5;
    final temp = report?.temperature ?? 17.0;
    final wind = report?.windSpeed ?? 12.0;

    final uvInfo = UvClassification.fromIndex(uv);
    final effectiveUv = uv < 1.0 ? 1.0 : uv;
    final safeMinutes = (settings.selectedPhototype.baseMedMinutes / effectiveUv).round().clamp(5, 240);

    final thermalNote = temp < 12
        ? 'Temperatura baja (${temp.toStringAsFixed(1)} °C): el frío andino oculta la sensación de quemadura solar; mantén protector FPS ${uvInfo.recommendedSpf}+.'
        : 'Temperatura templada (${temp.toStringAsFixed(1)} °C) con viento de ${wind.toStringAsFixed(1)} km/h: hidrátate y protege labios y rostro.';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fototipo de Piel (Escala Fitzpatrick)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<PhototypeOption>(
                  initialValue: settings.selectedPhototype,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: PhototypeOption.all
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Row(
                            children: [
                              CircleAvatar(radius: 9, backgroundColor: Color(p.colorHex)),
                              const SizedBox(width: 10),
                              Text('${p.label}: ${p.skinDescription}'),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (p) {
                    if (p != null) settings.setPhototype(p);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        RecommendationCard(
          icon: Icons.timer_outlined,
          title: 'Exposición segura sin protector: $safeMinutes minutos',
          body: 'Calculado para ${settings.selectedPhototype.label} con Índice UV ${uv.toStringAsFixed(1)} en ${settings.selectedDistrict.name}.',
        ),
        const SizedBox(height: 8),
        RecommendationCard(
          icon: Icons.shield_outlined,
          title: 'Protección recomendada: FPS ${uvInfo.recommendedSpf}+',
          body: uvInfo.protectionAdvice,
          accentColor: Colors.indigo,
        ),
        const SizedBox(height: 8),
        RecommendationCard(
          icon: Icons.terrain,
          title: 'Factor altitud (${settings.selectedDistrict.altitudeMeters} m s.n.m.)',
          body: 'En Cusco la atmósfera filtra menos radiación UVB. $thermalNote',
          accentColor: Colors.teal,
        ),
      ],
    );
  }
}