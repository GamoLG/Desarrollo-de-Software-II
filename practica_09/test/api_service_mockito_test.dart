import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:practica_09/models/post.dart';
import 'package:practica_09/services/api_service.dart';

// Anotación que indica a build_runner generar el mock tipado de http.Client
@GenerateMocks([http.Client])
import 'api_service_mockito_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock del MethodChannel de conectividad
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall methodCall) async => <String>['wifi'],
    );
  });

  group('Pruebas Unitarias con Mockito - ApiService', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('getPosts retorna List<Post> ante respuesta exitosa HTTP 200', () async {
      final jsonResponse = jsonEncode([
        {
          'userId': 1,
          'id': 1,
          'title': 'Título simulado con Mockito',
          'body': 'Cuerpo del post simulado'
        }
      ]);

      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonResponse, 200));

      final posts = await apiService.getPosts();

      expect(posts, isA<List<Post>>());
      expect(posts.length, 1);
      expect(posts.first.title, 'Título simulado con Mockito');
      verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
    });

    test('getPostById lanza ApiException ante respuesta HTTP 404', () async {
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/999'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
            () async => await apiService.getPostById(999),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );
    });
  });
}