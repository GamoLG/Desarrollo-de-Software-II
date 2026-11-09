import 'package:dio/dio.dart';
import '../../../../core/network/dio_factory.dart';
import '../domain/task.dart';

class TaskRepository {
  final Dio _dio;

  TaskRepository({Dio? dio}) : _dio = dio ?? DioFactory.create();

  Future<List<Task>> getTasks({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      '/todos',
      queryParameters: {'_page': page, '_limit': limit},
    );
    final list = response.data as List<dynamic>;
    return list.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Task> createTask(String title) async {
    final response = await _dio.post(
      '/todos',
      data: {'title': title, 'completed': false, 'userId': 1},
    );
    return Task.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Task> toggleTask(Task task) async {
    final response = await _dio.patch(
      '/todos/${task.id}',
      data: {'completed': !task.completed},
    );
    return task.copyWith(completed: !task.completed);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/todos/$id');
  }
}