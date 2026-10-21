import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const Practica08CompletaApp());
}

class Practica08CompletaApp extends StatelessWidget {
  const Practica08CompletaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 08 - Hardware y Sensores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MenuPrincipalScreen(),
    );
  }
}

class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Práctica 08: Hardware y Sensores'),
        backgroundColor: Colors.teal.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(Icons.map, color: Colors.teal.shade900),
                    ),
                    title: const Text('1. GPS y Seguimiento de Ruta',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Ubicación en tiempo real, OpenStreetMap y polilíneas.'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GpsScreen())),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(Icons.camera_alt, color: Colors.indigo.shade900),
                    ),
                    title: const Text('2. Cámara y Galería',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Captura fotográfica y selección de imágenes.'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CamaraScreen())),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.shade100,
                      child: Icon(Icons.screen_rotation, color: Colors.amber.shade900),
                    ),
                    title: const Text('3. Sensores y Nivel de Burbuja',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Acelerómetro, giroscopio, agitamiento y nivel.'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SensoresScreen())),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// MÓDULO 1: GPS Y MAPA INTERACTIVO (Guía 08.1)
// -------------------------------------------------------------
class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  final MapController _mapController = MapController();
  Position? _posActual;
  final List<LatLng> _ruta = [];
  double _distanciaRecorrida = 0.0;
  bool _rastreando = false;
  StreamSubscription<Position>? _posStream;

  @override
  void initState() {
    super.initState();
    _iniciarGps();
  }

  Future<void> _iniciarGps() async {
    bool servicio = await Geolocator.isLocationServiceEnabled();
    if (!servicio) return;

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        _posActual = pos;
        _ruta.add(LatLng(pos.latitude, pos.longitude));
      });
      _mapController.move(LatLng(pos.latitude, pos.longitude), 16.0);
    }
  }

  void _toggleRastreo() {
    if (_rastreando) {
      _posStream?.cancel();
      setState(() => _rastreando = false);
    } else {
      _posStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
      ).listen((pos) {
        final punto = LatLng(pos.latitude, pos.longitude);
        if (_posActual != null) {
          _distanciaRecorrida += Geolocator.distanceBetween(
            _posActual!.latitude, _posActual!.longitude, pos.latitude, pos.longitude,
          );
        }
        if (mounted) {
          setState(() {
            _posActual = pos;
            _ruta.add(punto);
            _rastreando = true;
          });
          _mapController.move(punto, _mapController.camera.zoom);
        }
      });
    }
  }

  @override
  void dispose() {
    _posStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng centro = _posActual != null
        ? LatLng(_posActual!.latitude, _posActual!.longitude)
        : const LatLng(-13.5319, -71.9675);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS y Seguimiento de Ruta'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: centro, initialZoom: 15.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.practica_08',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: _ruta, strokeWidth: 4.5, color: Colors.teal.shade700),
                ],
              ),
              if (_posActual != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_posActual!.latitude, _posActual!.longitude),
                      width: 45,
                      height: 45,
                      child: const Icon(Icons.my_location, color: Colors.redAccent, size: 36),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Distancia: ${_distanciaRecorrida.toStringAsFixed(1)} m', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Puntos: ${_ruta.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleRastreo,
        backgroundColor: _rastreando ? Colors.red : Colors.teal.shade800,
        foregroundColor: Colors.white,
        icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
        label: Text(_rastreando ? 'Detener' : 'Rastrear Ruta'),
      ),
    );
  }
}

// -------------------------------------------------------------
// MÓDULO 2: CÁMARA Y GALERÍA (Guía 08.1)
// -------------------------------------------------------------
class CamaraScreen extends StatefulWidget {
  const CamaraScreen({super.key});

  @override
  State<CamaraScreen> createState() => _CamaraScreenState();
}

class _CamaraScreenState extends State<CamaraScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imagen;

  Future<void> _capturar(ImageSource origen) async {
    final XFile? foto = await _picker.pickImage(source: origen, imageQuality: 85);
    if (foto != null) {
      setState(() => _imagen = File(foto.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y Galería'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: _imagen != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_imagen!, fit: BoxFit.cover),
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera, size: 64, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Sin imagen capturada', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade800, foregroundColor: Colors.white),
                  onPressed: () => _capturar(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
                  onPressed: () => _capturar(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// MÓDULO 3: SENSORES DE MOVIMIENTO (Guía 08.2)
// -------------------------------------------------------------
class SensoresScreen extends StatefulWidget {
  const SensoresScreen({super.key});

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  UserAccelerometerEvent? _movimiento;
  bool _agitado = false;
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _subs.add(accelerometerEventStream(samplingPeriod: const Duration(milliseconds: 50)).listen((e) {
      if (mounted) setState(() => _accel = e);
    }));
    _subs.add(gyroscopeEventStream(samplingPeriod: const Duration(milliseconds: 50)).listen((e) {
      if (mounted) setState(() => _gyro = e);
    }));
    _subs.add(userAccelerometerEventStream(samplingPeriod: const Duration(milliseconds: 50)).listen((e) {
      if (mounted) {
        setState(() => _movimiento = e);
        if (sqrt(e.x * e.x + e.y * e.y + e.z * e.z) > 15.0) {
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
                      Text('¡AGITAMIENTO DETECTADO!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Nivel de Burbuja (Inclinómetro)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    if (_accel != null)
                      CustomPaint(
                        size: const Size(200, 200),
                        painter: BurbujasPainter(
                          nx: (_accel!.x / 9.8).clamp(-1.0, 1.0),
                          ny: (_accel!.y / 9.8).clamp(-1.0, 1.0),
                        ),
                      )
                    else
                      const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    const SizedBox(height: 12),
                    Text(
                      _accel != null
                          ? 'Inclinación: ${(atan2(_accel!.y, sqrt(_accel!.x * _accel!.x + _accel!.z * _accel!.z)) * (180 / pi)).toStringAsFixed(1)}°'
                          : 'Esperando sensor...',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.sensors, color: Colors.amber),
                title: const Text('Acelerómetro'),
                subtitle: Text('X: ${_accel?.x.toStringAsFixed(2) ?? 0} | Y: ${_accel?.y.toStringAsFixed(2) ?? 0} | Z: ${_accel?.z.toStringAsFixed(2) ?? 0}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.rotate_right, color: Colors.blue),
                title: const Text('Giroscopio (rad/s)'),
                subtitle: Text('X: ${_gyro?.x.toStringAsFixed(2) ?? 0} | Y: ${_gyro?.y.toStringAsFixed(2) ?? 0} | Z: ${_gyro?.z.toStringAsFixed(2) ?? 0}'),
              ),
            ),
          ],
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
    final bool plano = nx.abs() < 0.05 && ny.abs() < 0.05;

    canvas.drawCircle(Offset(cx, cy), radio, Paint()..color = Colors.grey.shade300..style = PaintingStyle.stroke..strokeWidth = 2);
    final paintCruz = Paint()..color = Colors.grey..strokeWidth = 1;
    canvas.drawLine(Offset(cx - 10, cy), Offset(cx + 10, cy), paintCruz);
    canvas.drawLine(Offset(cx, cy - 10), Offset(cx, cy + 10), paintCruz);

    final bx = cx - nx * radio * 0.8;
    final by = cy + ny * radio * 0.8;
    canvas.drawCircle(Offset(bx, by), 20, Paint()..color = plano ? Colors.green : Colors.red.shade400);
  }

  @override
  bool shouldRepaint(covariant BurbujasPainter oldDelegate) => oldDelegate.nx != nx || oldDelegate.ny != ny;
}