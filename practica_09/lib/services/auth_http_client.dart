import 'package:http/http.dart' as http;

class AuthHttpClient extends http.BaseClient {
  final String token;
  final http.Client _inner;

  AuthHttpClient({
    required this.token,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Inyecta el Bearer Token automáticamente a cada petición
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}