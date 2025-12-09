import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import '../domain/usecases/todo/get_todos_usecase.dart';
import '../domain/usecases/todo/create_todo_usecase.dart';
import '../domain/usecases/todo/update_todo_usecase.dart';
import '../domain/usecases/todo/delete_todo_usecase.dart';
import '../domain/usecases/todo/toggle_todo_usecase.dart';
import '../models/todo/todo_model.dart';

class TodoController extends BaseListController<Todo> with BaseControllerMixin<Todo> {
  final GetTodosUseCase getTodosUseCase;
  final CreateTodoUseCase createTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;

  TodoController({
    required this.getTodosUseCase,
    required this.createTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
    required this.toggleTodoUseCase,
  }) {
    loadItems();
  }

  @override
  Future<void> loadItems() async {
    await handleListResult(() => getTodosUseCase());
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
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await handleResult(
      () => updateTodoUseCase(updated),
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
      () => deleteTodoUseCase(id),
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

