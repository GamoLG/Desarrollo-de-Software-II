import 'package:dio/dio.dart';
import '../models/post.dart';

class DioApiService {
  late final Dio _dio;

  DioApiService({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: 'https://jsonplaceholder.typicode.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    // Funcionalidad avanzada 1: Interceptores globales
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Inyección automática de cabeceras de autorización
          options.headers['Authorization'] = 'Bearer token_dio_demo';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // Registro o manejo centralizado de errores de red
          return handler.next(error);
        },
      ),
    );
  }

  // Funcionalidad avanzada 2: Parseo automático sin requerir json.decode()
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception('DioException [${e.response?.statusCode}]: ${e.message}');
    }
  }

  // Funcionalidad avanzada 3: Envío directo de Maps en el body
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {
          'title': title,
          'body': body,
          'userId': userId,
        },
      );
      return Post.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al crear post con Dio: ${e.message}');
    }
  }
}