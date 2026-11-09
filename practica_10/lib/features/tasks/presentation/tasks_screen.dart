import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/token_storage.dart';
import 'task_notifier.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(taskListProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: 'Descripción de la tarea...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _taskController.text.trim();
              if (text.isNotEmpty) {
                ref.read(taskListProvider.notifier).addTask(text);
                _taskController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión To-Do (JWT + Riverpod)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión / Limpiar tokens',
            onPressed: () async {
              await TokenStorage.clear();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tokens JWT eliminados del SecureStorage')),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 50, color: Colors.amber),
              const SizedBox(height: 12),
              Text('Error: $err', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(taskListProvider.notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (tasks) => RefreshIndicator(
          onRefresh: () => ref.read(taskListProvider.notifier).refresh(),
          child: tasks.isEmpty
              ? const Center(child: Text('No hay tareas disponibles.'))
              : ListView.separated(
            controller: _scrollController,
            itemCount: tasks.length + 1,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index == tasks.length) {
                final hasMore = ref.watch(taskListProvider.notifier).hasMore;
                return hasMore
                    ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('No hay más tareas para cargar.'),
                  ),
                );
              }

              final task = tasks[index];
              return ListTile(
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (_) {
                    ref.read(taskListProvider.notifier).toggleTask(task);
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    ref.read(taskListProvider.notifier).removeTask(task.id);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}