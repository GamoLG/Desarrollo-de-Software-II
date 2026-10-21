import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class GpsMapaScreen extends StatefulWidget {
  const GpsMapaScreen({super.key});

  @override
  State<GpsMapaScreen> createState() => _GpsMapaScreenState();
}

class _GpsMapaScreenState extends State<GpsMapaScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  Position? _posActual;
  final List<LatLng> _ruta = [];
  double _distanciaRecorrida = 0.0;
  bool _rastreando = false;
  StreamSubscription<Position>? _posStream;

  @override
  void initState() {
    super.initState();
    _iniciarUbicacion();
  }

  Future<void> _iniciarUbicacion() async {
    try {
      final pos = await _locationService.obtenerPosicion();
      if (mounted) {
        setState(() {
          _posActual = pos;
          _ruta.add(LatLng(pos.latitude, pos.longitude));
        });
        _mapController.move(LatLng(pos.latitude, pos.longitude), 16.0);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _toggleRastreo() {
    if (_rastreando) {
      _posStream?.cancel();
      setState(() => _rastreando = false);
    } else {
      _posStream = _locationService.rastrearPosicion().listen((pos) {
        final puntoNuevo = LatLng(pos.latitude, pos.longitude);

        if (_posActual != null) {
          _distanciaRecorrida += _locationService.calcularDistancia(_posActual!, pos);
        }

        if (mounted) {
          setState(() {
            _posActual = pos;
            _ruta.add(puntoNuevo);
            _rastreando = true;
          });
          _mapController.move(puntoNuevo, _mapController.camera.zoom);
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
        : const LatLng(-13.5319, -71.9675); // Cusco centro por defecto

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
            options: MapOptions(
              initialCenter: centro,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.practica_08',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _ruta,
                    strokeWidth: 4.5,
                    color: Colors.teal.shade700,
                  ),
                ],
              ),
              if (_posActual != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_posActual!.latitude, _posActual!.longitude),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.redAccent,
                        size: 38,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Tarjeta de telemetría y coordenadas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.place, color: Colors.teal.shade800),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _posActual != null
                                ? 'Lat: ${_posActual!.latitude.toStringAsFixed(5)}, Lng: ${_posActual!.longitude.toStringAsFixed(5)}'
                                : 'Obteniendo señal GPS...',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Distancia: ${_distanciaRecorrida.toStringAsFixed(1)} m'),
                        Text('Puntos ruta: ${_ruta.length}'),
                      ],
                    ),
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