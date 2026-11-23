import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: ListTile(
            leading: Icon(Icons.wb_sunny, color: Color(0xFFE65100), size: 32),
            title: Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Versión ${AppConstants.appVersion} · ID: ${AppConstants.bundleId}'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Política de Privacidad y Uso de Datos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 8),
                Text(
                  '• WayraUV Cusco no requiere registro de usuario ni recolecta nombre, correo, teléfono o ubicación GPS precisa.\n'
                      '• Al consultar el pronóstico, se envían únicamente las coordenadas fijas del distrito seleccionado a Open-Meteo (API meteorológica pública).\n'
                      '• Tus preferencias (distrito, fototipo y umbral de alertas) se almacenan exclusivamente de forma local en tu dispositivo.',
                ),
                SizedBox(height: 10),
                Text('URL pública: ${AppConstants.privacyPolicyUrl}',
                    style: TextStyle(fontSize: 12, color: Colors.indigo)),
                Text('Soporte: ${AppConstants.supportEmail}',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}