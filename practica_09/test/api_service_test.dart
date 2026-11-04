import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_09/models/comment.dart';
import 'package:practica_09/models/post.dart';
import 'package:practica_09/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall methodCall) async => <String>['wifi'],
    );
  });

  group('Pruebas Unitarias - ApiService', () {
    test('getPosts retorna una lista de posts en caso de éxito (200)', () async {
      final mockResponse = json.encode([
        {'userId': 1, 'id': 1, 'title': 'Test Post 1', 'body': 'Test Body 1'},
        {'userId': 1, 'id': 2, 'title': 'Test Post 2', 'body': 'Test Body 2'},
      ]);

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200, headers: {'content-type': 'application/json'});
      });

      final apiService = ApiService(client: client);
      final posts = await apiService.getPosts();

      expect(posts, isA<List<Post>>());
      expect(posts.length, 2);
      expect(posts.first.title, 'Test Post 1');
    });

    test('getPostById retorna un Post cuando la respuesta es 200', () async {
      final mockResponse = json.encode(
        {'userId': 1, 'id': 1, 'title': 'Post Individual', 'body': 'Contenido'},
      );

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200, headers: {'content-type': 'application/json'});
      });

      final apiService = ApiService(client: client);
      final post = await apiService.getPostById(1);

      expect(post, isA<Post>());
      expect(post.id, 1);
      expect(post.title, 'Post Individual');
    });

    test('getPostById lanza ApiException cuando la respuesta es 404', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: client);

      expect(
            () async => await apiService.getPostById(999),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );
    });

    test('getCommentsByPost retorna los comentarios asociados a un postId', () async {
      final mockResponse = json.encode([
        {'postId': 1, 'id': 1, 'name': 'Juan', 'email': 'juan@test.com', 'body': 'Comentario'}
      ]);

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200, headers: {'content-type': 'application/json'});
      });

      final apiService = ApiService(client: client);
      final comments = await apiService.getCommentsByPost(1);

      expect(comments, isA<List<Comment>>());
      expect(comments.first.postId, 1);
    });
  });
}