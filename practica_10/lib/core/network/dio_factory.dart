import 'package:dio/dio.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Simulación de endpoint de refresh token
          final response = await Dio().post(
            'https://reqres.in/api/login',
            data: {'email': 'eve.holt@reqres.in', 'refresh': refreshToken},
          );

          final newToken = response.data['token'] as String? ?? 'refreshed_jwt_token_sample';
          await TokenStorage.saveTokens(access: newToken, refresh: refreshToken);

          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newToken';
          final cloneReq = await dio.fetch(retryOptions);
          return handler.resolve(cloneReq);
        } catch (_) {
          await TokenStorage.clear();
        }
      }
    }
    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('<-- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('<-- ERROR [${err.response?.statusCode}]: ${err.message}');
    handler.next(err);
  }
}

class DioFactory {
  static Dio create({String baseUrl = 'https://jsonplaceholder.typicode.com'}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(dio),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}