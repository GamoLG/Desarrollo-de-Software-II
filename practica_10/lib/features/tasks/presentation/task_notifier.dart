import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_repository.dart';
import '../domain/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());

final taskListProvider = AsyncNotifierProvider<TaskListNotifier, List<Task>>(
  TaskListNotifier.new,
);

class TaskListNotifier extends AsyncNotifier<List<Task>> {
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  FutureOr<List<Task>> build() async {
    _currentPage = 1;
    _hasMore = true;
    return ref.read(taskRepositoryProvider).getTasks(page: _currentPage, limit: 10);
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
          () => ref.read(taskRepositoryProvider).getTasks(page: _currentPage, limit: 10),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;
    final currentTasks = state.value ?? [];
    _currentPage++;

    try {
      final newTasks = await ref
          .read(taskRepositoryProvider)
          .getTasks(page: _currentPage, limit: 10);

      if (newTasks.isEmpty) {
        _hasMore = false;
      } else {
        state = AsyncData([...currentTasks, ...newTasks]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addTask(String title) async {
    final newTask = await ref.read(taskRepositoryProvider).createTask(title);
    final currentTasks = state.value ?? [];
    state = AsyncData([newTask, ...currentTasks]);
  }

  Future<void> toggleTask(Task task) async {
    final updated = await ref.read(taskRepositoryProvider).toggleTask(task);
    final currentTasks = state.value ?? [];
    state = AsyncData(
      currentTasks.map((t) => t.id == task.id ? updated : t).toList(),
    );
  }

  Future<void> removeTask(int id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
    final currentTasks = state.value ?? [];
    state = AsyncData(currentTasks.where((t) => t.id != id).toList());
  }
}