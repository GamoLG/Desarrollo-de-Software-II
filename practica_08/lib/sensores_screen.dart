import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensoresScreen extends StatefulWidget {
  const SensoresScreen({super.key});

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  UserAccelerometerEvent? _userAccel;
  bool _agitado = false;

  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _subs.add(accelerometerEventStream().listen((event) {
      if (mounted) setState(() => _accel = event);
    }));

    _subs.add(gyroscopeEventStream().listen((event) {
      if (mounted) setState(() => _gyro = event);
    }));

    _subs.add(userAccelerometerEventStream().listen((event) {
      if (mounted) {
        setState(() => _userAccel = event);
        final magnitud = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (magnitud > 15.0) {
          setState(() => _agitado = true);
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) setState(() => _agitado = false);
          });
        }
      }
    }));
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores y Nivel de Burbuja'),
        backgroundColor: Colors.amber.shade900,
        foregroundColor: Colors.white,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _agitado ? Colors.red.shade100 : Colors.grey.shade50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_agitado)
                Card(
                  color: Colors.red.shade600,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.vibration, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '¡DISPOSITIVO AGITADO!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Nivel de Burbuja (Inclinómetro)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      if (_accel != null)
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: BurbujasPainter(
                            nx: (_accel!.x / 9.8).clamp(-1.0, 1.0),
                            ny: (_accel!.y / 9.8).clamp(-1.0, 1.0),
                          ),
                        )
                      else
                        const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(
                        _accel != null
                            ? 'Inclinación: ${(atan2(_accel!.y, sqrt(_accel!.x * _accel!.x + _accel!.z * _accel!.z)) * (180 / pi)).toStringAsFixed(1)}°'
                            : 'Leyendo sensor...',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.speed, color: Colors.amber),
                        title: const Text('Acelerómetro (con gravedad)'),
                        subtitle: Text(
                          'X: ${_accel?.x.toStringAsFixed(2) ?? 0} | Y: ${_accel?.y.toStringAsFixed(2) ?? 0} | Z: ${_accel?.z.toStringAsFixed(2) ?? 0}',
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.rotate_right, color: Colors.blue),
                        title: const Text('Giroscopio (rad/s)'),
                        subtitle: Text(
                          'X: ${_gyro?.x.toStringAsFixed(2) ?? 0} | Y: ${_gyro?.y.toStringAsFixed(2) ?? 0} | Z: ${_gyro?.z.toStringAsFixed(2) ?? 0}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BurbujasPainter extends CustomPainter {
  final double nx, ny;

  BurbujasPainter({required this.nx, required this.ny});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radio = size.width / 2 - 10;
    final bool plano = nx.abs() < 0.08 && ny.abs() < 0.08;

    canvas.drawCircle(
      Offset(cx, cy),
      radio,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final paintCruz = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx - 15, cy), Offset(cx + 15, cy), paintCruz);
    canvas.drawLine(Offset(cx, cy - 15), Offset(cx, cy + 15), paintCruz);

    final bx = cx - nx * radio * 0.8;
    final by = cy + ny * radio * 0.8;
    canvas.drawCircle(
      Offset(bx, by),
      18,
      Paint()..color = plano ? Colors.green : Colors.redAccent,
    );
  }

  @override
  bool shouldRepaint(covariant BurbujasPainter oldDelegate) =>
      oldDelegate.nx != nx || oldDelegate.ny != ny;
}