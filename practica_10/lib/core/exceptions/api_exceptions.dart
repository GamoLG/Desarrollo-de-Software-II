sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException()
      : super('Sin conexión a internet. Verifica tu red móvil o Wi-Fi.');
}

class TimeoutException extends ApiException {
  const TimeoutException()
      : super('La petición tardó demasiado en responder. Intenta de nuevo.');
}

class ApiKeyException extends ApiException {
  const ApiKeyException()
      : super('API Key inválida o no autorizada. Revisa tus credenciales.');
}

class CityNotFoundException extends ApiException {
  final String city;
  const CityNotFoundException(this.city)
      : super('No se encontró la ciudad "$city". Verifica el nombre.');
}

class ServerException extends ApiException {
  final int statusCode;
  const ServerException(this.statusCode)
      : super('Error en el servidor de OpenWeatherMap (Código: $statusCode).');
}

class ParseException extends ApiException {
  final String details;
  const ParseException(this.details)
      : super('Error al procesar la respuesta meteorológica: $details');
}