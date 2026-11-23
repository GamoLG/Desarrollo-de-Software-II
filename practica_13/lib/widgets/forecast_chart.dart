import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class ForecastChart extends StatelessWidget {
  final List<HourlyUvPoint> points;

  const ForecastChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Sin datos horarios disponibles.'),
        ),
      );
    }

    final spots = points
        .map((p) => FlSpot(p.hour.toDouble(), double.parse(p.uvIndex.toStringAsFixed(1))))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curva de Radiación UV por Hora (06:00 – 18:00)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 16,
                  gridData: const FlGridData(show: true, horizontalInterval: 4),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 4,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 11)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 3,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}h', style: const TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFFE65100),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFE65100).withValues(alpha: 0.16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}