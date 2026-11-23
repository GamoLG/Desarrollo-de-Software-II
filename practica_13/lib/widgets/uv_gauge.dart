import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/uv_model.dart';

class UvGauge extends StatelessWidget {
  final double uvIndex;
  final int altitudeMeters;

  const UvGauge({
    super.key,
    required this.uvIndex,
    required this.altitudeMeters,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.uvColor(uvIndex);
    final info = UvClassification.fromIndex(uvIndex);
    final progress = (uvIndex / 15.0).clamp(0.05, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: color,
                  label: Text(
                    'RIESGO ${info.level}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '$altitudeMeters m s.n.m.',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 14,
                      backgroundColor: color.withValues(alpha: 0.15),
                      color: color,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        uvIndex.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                      const Text('Índice UV', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              info.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}