import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10/features/tasks/data/task_repository.dart';
import 'package:practica_10/features/tasks/domain/task.dart';

class MockAdapter implements HttpClientAdapter {
  final ResponseBody responseBody;
  MockAdapter(this.responseBody);

  @override
  Future<ResponseBody> fetch(
      RequestOptions options,
      Stream<Uint8List>? requestStream,
      Future<void>? cancelFuture,
      ) async {
    return responseBody;
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ejercicio 2: TaskRepository Tests', () {
    test('getTasks parsea correctamente la lista de tareas simulada', () async {
      final mockData = jsonEncode([
        {'id': 1, 'title': 'Estudiar Riverpod', 'completed': false},
        {'id': 2, 'title': 'Configurar interceptor Dio', 'completed': true},
        {'id': 3, 'title': 'Persistir token JWT', 'completed': false},
      ]);

      final dio = Dio();
      dio.httpClientAdapter = MockAdapter(
        ResponseBody.fromString(
          mockData,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final repository = TaskRepository(dio: dio);
      final tasks = await repository.getTasks(page: 1, limit: 3);

      expect(tasks, isNotEmpty);
      expect(tasks.length, 3);
      expect(tasks.first.title, 'Estudiar Riverpod');
      expect(tasks[1].completed, isTrue);
    });

    test('createTask envía y procesa la nueva tarea con éxito', () async {
      final createdData = jsonEncode({
        'id': 101,
        'title': 'Completar informe técnico',
        'completed': false,
        'userId': 1,
      });

      final dio = Dio();
      dio.httpClientAdapter = MockAdapter(
        ResponseBody.fromString(
          createdData,
          201,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final repository = TaskRepository(dio: dio);
      final newTask = await repository.createTask('Completar informe técnico');

      expect(newTask.id, 101);
      expect(newTask.title, 'Completar informe técnico');
      expect(newTask.completed, isFalse);
    });
  });
}