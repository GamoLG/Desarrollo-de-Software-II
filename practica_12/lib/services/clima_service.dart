import 'dart:convert';
import 'package:http/http.dart' as http;

typedef ClimaData = Map<String, dynamic>;

class ClimaService {
  Future<ClimaData> obtenerClimaCusco() async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=-13.5320&longitude=-71.9675&current=temperature_2m,wind_speed_10m',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ClimaData.from(data['current']);
    }
    throw Exception('Error al consultar clima: ${response.statusCode}');
  }
}