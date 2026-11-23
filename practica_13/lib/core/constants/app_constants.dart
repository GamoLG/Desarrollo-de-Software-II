import '../../models/district_model.dart';

class AppConstants {
  static const String appName = 'WayraUV Cusco';
  static const String appVersion = '1.0.0+1';
  static const String bundleId = 'io.github.gamolg.wayrauv';
  static const String privacyPolicyUrl = 'https://gamolg.github.io/wayrauv-privacy/';
  static const String supportEmail = 'gamolg.dev@gmail.com';

  static const List<DistrictModel> cuscoDistricts = [
    DistrictModel(
      id: 'centro',
      name: 'Centro Histórico',
      altitudeMeters: 3399,
      latitude: -13.5167,
      longitude: -71.9788,
    ),
    DistrictModel(
      id: 'wanchaq',
      name: 'Wanchaq',
      altitudeMeters: 3365,
      latitude: -13.5245,
      longitude: -71.9630,
    ),
    DistrictModel(
      id: 'san_sebastian',
      name: 'San Sebastián',
      altitudeMeters: 3295,
      latitude: -13.5250,
      longitude: -71.9360,
    ),
    DistrictModel(
      id: 'san_jeronimo',
      name: 'San Jerónimo',
      altitudeMeters: 3244,
      latitude: -13.5436,
      longitude: -71.8856,
    ),
    DistrictModel(
      id: 'sacsayhuaman',
      name: 'Sacsayhuamán',
      altitudeMeters: 3700,
      latitude: -13.5097,
      longitude: -71.9817,
    ),
  ];
}