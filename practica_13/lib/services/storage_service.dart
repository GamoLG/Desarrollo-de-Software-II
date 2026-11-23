import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _keyDistrict = 'selected_district_id';
  static const String _keyPhototype = 'selected_phototype';
  static const String _keyUvThreshold = 'uv_alert_threshold';
  static const String _keyAlertsEnabled = 'uv_alerts_enabled';
  static const String _keyReminderMinutes = 'sunscreen_reminder_minutes';

  Future savePreferences({
    required String districtId,
    required int phototype,
    required double uvThreshold,
    required bool alertsEnabled,
    required int reminderMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDistrict, districtId);
    await prefs.setInt(_keyPhototype, phototype);
    await prefs.setDouble(_keyUvThreshold, uvThreshold);
    await prefs.setBool(_keyAlertsEnabled, alertsEnabled);
    await prefs.setInt(_keyReminderMinutes, reminderMinutes);
  }

  Future loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'districtId': prefs.getString(_keyDistrict) ?? 'centro',
      'phototype': prefs.getInt(_keyPhototype) ?? 3,
      'uvThreshold': prefs.getDouble(_keyUvThreshold) ?? 8.0,
      'alertsEnabled': prefs.getBool(_keyAlertsEnabled) ?? true,
      'reminderMinutes': prefs.getInt(_keyReminderMinutes) ?? 120,
    };
  }

  Future cacheReport(WeatherReport report) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_${report.districtId}', jsonEncode(report.toJson()));
  }

  Future getCachedReport(String districtId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$districtId');
    if (raw == null) return null;
    try {
      return WeatherReport.fromJson(
        jsonDecode(raw),
        cached: true,
      );
    } catch (_) {
      return null;
    }
  }
}