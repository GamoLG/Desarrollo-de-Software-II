import 'package:flutter_test/flutter_test.dart';
import 'package:practica_13/core/constants/app_constants.dart';
import 'package:practica_13/models/uv_model.dart';

void main() {
  test('Clasificación UV identifica correctamente riesgo extremo en Cusco', () {
    final info = UvClassification.fromIndex(12.5);
    expect(info.level, 'EXTREMO');
    expect(info.recommendedSpf, 50);
  });

  test('Constantes contienen los 5 sectores monitoreados de Cusco', () {
    expect(AppConstants.cuscoDistricts.length, 5);
    expect(AppConstants.bundleId, 'io.github.gamolg.wayrauv');
  });
}