import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/district_model.dart';
import '../models/uv_model.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  DistrictModel _selectedDistrict = AppConstants.cuscoDistricts.first;
  PhototypeOption _selectedPhototype = PhototypeOption.all[2];
  double _uvThreshold = 8.0;
  bool _alertsEnabled = true;
  int _reminderMinutes = 120;

  DistrictModel get selectedDistrict => _selectedDistrict;
  PhototypeOption get selectedPhototype => _selectedPhototype;
  double get uvThreshold => _uvThreshold;
  bool get alertsEnabled => _alertsEnabled;
  int get reminderMinutes => _reminderMinutes;

  Future<void> load() async {
    final data = await _storage.loadPreferences();
    final dId = data['districtId'] as String;
    _selectedDistrict = AppConstants.cuscoDistricts.firstWhere(
      (d) => d.id == dId,
      orElse: () => AppConstants.cuscoDistricts.first,
    );
    final pType = data['phototype'] as int;
    _selectedPhototype = PhototypeOption.all.firstWhere(
      (p) => p.type == pType,
      orElse: () => PhototypeOption.all[2],
    );
    _uvThreshold = data['uvThreshold'] as double;
    _alertsEnabled = data['alertsEnabled'] as bool;
    _reminderMinutes = data['reminderMinutes'] as int;
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storage.savePreferences(
      districtId: _selectedDistrict.id,
      phototype: _selectedPhototype.type,
      uvThreshold: _uvThreshold,
      alertsEnabled: _alertsEnabled,
      reminderMinutes: _reminderMinutes,
    );
  }

  Future<void> setDistrict(DistrictModel district) async {
    _selectedDistrict = district;
    notifyListeners();
    await _persist();
  }

  Future<void> setPhototype(PhototypeOption phototype) async {
    _selectedPhototype = phototype;
    notifyListeners();
    await _persist();
  }

  Future<void> setUvThreshold(double value) async {
    _uvThreshold = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setAlertsEnabled(bool value) async {
    _alertsEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setReminderMinutes(int minutes) async {
    _reminderMinutes = minutes;
    notifyListeners();
    await _persist();
  }
}