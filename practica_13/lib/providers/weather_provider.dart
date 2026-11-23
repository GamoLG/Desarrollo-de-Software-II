import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/district_model.dart';
import '../models/weather_model.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storage = StorageService();
  final NotificationService _notifications = NotificationService();

  WeatherReport? _currentReport;
  final Map<String, WeatherReport> _districtReports = {};
  List<HourlyUvPoint> _plannerForecast = [];
  bool _isLoading = false;
  String? _errorMessage;

  WeatherReport? get currentReport => _currentReport;
  Map<String, WeatherReport> get districtReports => _districtReports;
  List<HourlyUvPoint> get plannerForecast => _plannerForecast;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> refreshDistrict(
      DistrictModel district, {
        bool alertsEnabled = false,
        double uvThreshold = 8.0,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final report = await _weatherService.fetchDistrictWeather(district);
      _currentReport = report;
      _districtReports[district.id] = report;
      _plannerForecast = report.hourlyForecast;
      await _storage.cacheReport(report);

      if (alertsEnabled && report.currentUv >= uvThreshold) {
        await _notifications.showUvAlert(
          districtName: district.name,
          uvIndex: report.currentUv,
        );
      }
    } catch (_) {
      final cached = await _storage.getCachedReport(district.id);
      if (cached != null) {
        _currentReport = cached;
        _districtReports[district.id] = cached;
        _plannerForecast = cached.hourlyForecast;
        _errorMessage = 'Mostrando última lectura guardada (sin conexión).';
      } else {
        _currentReport = _fallbackReport(district.id);
        _plannerForecast = _currentReport!.hourlyForecast;
        _errorMessage = 'Sin conexión: valores referenciales para altitud andina.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlannerForDate(DistrictModel district, DateTime date) async {
    _isLoading = true;
    notifyListeners();
    try {
      final report = await _weatherService.fetchDistrictWeather(district, targetDate: date);
      _plannerForecast = report.hourlyForecast;
    } catch (_) {
      _plannerForecast = _fallbackReport(district.id).hourlyForecast;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllDistricts() async {
    _isLoading = true;
    notifyListeners();
    for (final d in AppConstants.cuscoDistricts) {
      try {
        final report = await _weatherService.fetchDistrictWeather(d);
        _districtReports[d.id] = report;
        await _storage.cacheReport(report);
      } catch (_) {
        final cached = await _storage.getCachedReport(d.id);
        _districtReports[d.id] = cached ?? _fallbackReport(d.id);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> triggerTestAlert(String districtName, double uv) async {
    await _notifications.showUvAlert(districtName: districtName, uvIndex: uv);
  }

  WeatherReport _fallbackReport(String districtId) {
    final curve = <HourlyUvPoint>[
      const HourlyUvPoint(hour: 6, uvIndex: 0.4, temperature: 8.0),
      const HourlyUvPoint(hour: 8, uvIndex: 3.2, temperature: 12.5),
      const HourlyUvPoint(hour: 10, uvIndex: 8.5, temperature: 16.0),
      const HourlyUvPoint(hour: 12, uvIndex: 12.4, temperature: 19.2),
      const HourlyUvPoint(hour: 14, uvIndex: 11.1, temperature: 18.8),
      const HourlyUvPoint(hour: 16, uvIndex: 5.4, temperature: 15.4),
      const HourlyUvPoint(hour: 18, uvIndex: 0.6, temperature: 11.2),
    ];
    return WeatherReport(
      districtId: districtId,
      currentUv: 11.2,
      temperature: 18.0,
      humidity: 44,
      windSpeed: 13.5,
      cloudCover: 25,
      updatedAt: DateTime.now(),
      isFromCache: true,
      hourlyForecast: curve,
    );
  }
}