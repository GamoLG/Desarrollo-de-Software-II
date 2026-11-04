import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
import '../models/post.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException [$statusCode]: $message';
}

class ApiService {
  final String _baseUrl;
  final http.Client _client;

  ApiService({
    String baseUrl = 'https://jsonplaceholder.typicode.com',
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // GET ALL POSTS
  Future<List<Post>> getPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Post.fromJson(j as Map<String, dynamic>)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener los posts',
      );
    }
  }

  // GET POST BY ID
  Future<Post> getPostById(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener el post $id',
      );
    }
  }

  // CREATE POST
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al crear el post',
      );
    }
  }

  // GET COMMENTS
  Future<List<Comment>> getCommentsByPost(int postId) async {
    final uri = Uri.parse('$_baseUrl/posts/$postId/comments');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Comment.fromJson(j as Map<String, dynamic>)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener los comentarios',
      );
    }
  }

  // PROPUESTO 4.A: Paginación Numérica
  Future<List<Post>> getPostsPaginated({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('$_baseUrl/posts?_page=$page&_limit=$limit');
    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Post.fromJson(j as Map<String, dynamic>)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener posts por página numérica',
      );
    }
  }

  // PROPUESTO 4.B: Paginación por Cursor
  Future<List<Post>> getPostsByCursor({int startAfterId = 0, int limit = 10}) async {
    final uri = Uri.parse('$_baseUrl/posts?_start=$startAfterId&_limit=$limit');
    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Post.fromJson(j as Map<String, dynamic>)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener posts por cursor',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}