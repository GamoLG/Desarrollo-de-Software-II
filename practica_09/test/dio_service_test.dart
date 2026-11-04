import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09/models/post.dart';
import 'package:practica_09/services/dio_api_service.dart';

void main() {
  test('DioApiService obtiene posts reales de JSONPlaceholder', () async {
    final dioService = DioApiService();
    final posts = await dioService.getPosts();

    expect(posts, isA<List<Post>>());
    expect(posts.isNotEmpty, true);
    expect(posts.first.title.isNotEmpty, true);
  });
}