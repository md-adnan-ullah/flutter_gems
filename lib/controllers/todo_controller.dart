import 'package:get/get.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import '../models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoController extends BaseListController<Todo> {
  final TodoRepository repository;

  TodoController(this.repository) {
    loadItems();
  }

  @override
  Future<void> loadItems() async {
    setLoading(true);
    final response = await repository.getAll(
      useCache: true,
      cacheTTL: const Duration(minutes: 5),
    );
    
    if (response.success && response.data != null) {
      addItems(response.data!);
    } else {
      setError(response.message ?? 'Failed to load todos');
    }
    setLoading(false);
  }

  Future<void> createTodo(String title, {String? description}) async {
    setLoading(true);
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    final response = await repository.create(
      todo,
      syncOffline: true,
    );

    if (response.success && response.data != null) {
      items.insert(0, response.data!);
      Get.snackbar('Success', 'Todo created successfully');
    } else {
      setError(response.message ?? 'Failed to create todo');
      Get.snackbar('Error', response.message ?? 'Failed to create todo');
    }
    setLoading(false);
  }

  Future<void> updateTodo(Todo todo) async {
    setLoading(true);
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedAt: DateTime.now(),
    );

    final response = await repository.update(
      todo.id,
      updatedTodo,
      syncOffline: true,
    );

    if (response.success && response.data != null) {
      final index = items.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        items[index] = response.data!;
      }
      Get.snackbar('Success', 'Todo updated successfully');
    } else {
      setError(response.message ?? 'Failed to update todo');
      Get.snackbar('Error', response.message ?? 'Failed to update todo');
    }
    setLoading(false);
  }

  Future<void> deleteTodo(String id) async {
    setLoading(true);
    final response = await repository.delete(id, syncOffline: true);

    if (response.success) {
      items.removeWhere((t) => t.id == id);
      Get.snackbar('Success', 'Todo deleted successfully');
    } else {
      setError(response.message ?? 'Failed to delete todo');
      Get.snackbar('Error', response.message ?? 'Failed to delete todo');
    }
    setLoading(false);
  }

  void toggleTodo(Todo todo) {
    updateTodo(todo);
  }
}

