import 'package:geolocator/geolocator.dart';

class LocationService {
  static const LocationSettings highAccuracy = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  Future<void> verificarPermisos() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('El servicio de GPS está desactivado. Actívalo en tu dispositivo.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Permiso denegado permanentemente. Actívalo en Ajustes.');
    }
  }

  Future<Position> obtenerPosicion() async {
    await verificarPermisos();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  Stream<Position> rastrearPosicion() {
    return Geolocator.getPositionStream(locationSettings: highAccuracy);
  }

  double calcularDistancia(Position a, Position b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}