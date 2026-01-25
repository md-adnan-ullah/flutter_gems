import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import '../domain/usecases/todo/create_todo_usecase.dart';
import '../domain/usecases/todo/toggle_todo_usecase.dart';
import '../models/todo/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoController extends BaseListController<Todo> with BaseControllerMixin<Todo> {
  final TodoRepository repository;
  final CreateTodoUseCase createTodoUseCase; // Has validation logic
  final ToggleTodoUseCase toggleTodoUseCase; // Has business logic

  TodoController({
    required this.repository,
    required this.createTodoUseCase,
    required this.toggleTodoUseCase,
  }) {
    loadItems();
  }

  @override
  Future<void> loadItems() async {
    await handleListResult(() => repository.getAllTodos());
  }

  Future<void> createTodo(String title, {int userId = 1}) async {
    await handleResult(
      () => createTodoUseCase(title: title, userId: userId),
      onSuccess: (todo) => items.insert(0, todo),
      showSuccessMessage: true,
      successMessage: 'Todo created successfully',
    );
  }

  Future<void> updateTodo(Todo todo) async {
    await handleResult(
      () => repository.updateTodo(todo),
      onSuccess: (todo) {
        final index = items.indexWhere((t) => t.id == todo.id);
        if (index != -1) items[index] = todo;
      },
      showSuccessMessage: true,
      successMessage: 'Todo updated successfully',
    );
  }

  Future<void> deleteTodo(String id) async {
    await handleResult(
      () => repository.deleteTodo(id),
      onSuccess: (_) => items.removeWhere((t) => t.id == id),
      showSuccessMessage: true,
      successMessage: 'Todo deleted successfully',
    );
  }

  void toggleTodo(Todo todo) async {
    await handleResult(
      () => toggleTodoUseCase(todo.id),
      onSuccess: (todo) {
        final index = items.indexWhere((t) => t.id == todo.id);
        if (index != -1) items[index] = todo;
      },
      showSuccessMessage: true,
      successMessage: 'Todo updated successfully',
    );
  }
}

