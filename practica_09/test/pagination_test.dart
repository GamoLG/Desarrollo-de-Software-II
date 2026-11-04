import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_09/models/post.dart';
import 'package:practica_09/services/api_service.dart';

void main() {
  group('Propuesto 4 - Pruebas de Paginación', () {
    test('getPostsPaginated solicita la página y límite correctos', () async {
      late Uri requestedUri;
      final mockClient = MockClient((request) async {
        requestedUri = request.url;
        final mockList = List.generate(
          5,
              (i) => {'userId': 1, 'id': i + 1, 'title': 'Post $i', 'body': 'Body $i'},
        );
        return http.Response(json.encode(mockList), 200);
      });

      final apiService = ApiService(client: mockClient);
      final posts = await apiService.getPostsPaginated(page: 2, limit: 5);

      expect(posts.length, 5);
      expect(requestedUri.queryParameters['_page'], '2');
      expect(requestedUri.queryParameters['_limit'], '5');
    });

    test('getPostsByCursor solicita el inicio (start) y límite correctos', () async {
      late Uri requestedUri;
      final mockClient = MockClient((request) async {
        requestedUri = request.url;
        final mockList = [
          {'userId': 1, 'id': 11, 'title': 'Post 11', 'body': 'Body 11'}
        ];
        return http.Response(json.encode(mockList), 200);
      });

      final apiService = ApiService(client: mockClient);
      final posts = await apiService.getPostsByCursor(startAfterId: 10, limit: 10);

      expect(posts.length, 1);
      expect(requestedUri.queryParameters['_start'], '10');
      expect(requestedUri.queryParameters['_limit'], '10');
    });
  });
}