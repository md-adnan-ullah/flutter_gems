import 'package:get/get.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import '../domain/usecases/todo/get_todos_usecase.dart';
import '../domain/usecases/todo/create_todo_usecase.dart';
import '../domain/usecases/todo/update_todo_usecase.dart';
import '../domain/usecases/todo/delete_todo_usecase.dart';
import '../domain/usecases/todo/toggle_todo_usecase.dart';
import '../models/todo/todo_model.dart';

class TodoController extends BaseListController<Todo> {
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
    setLoading(true);
    final result = await getTodosUseCase();
    result.when(
      success: (todos) => addItems(todos),
      failure: (error) {
        setError(error.message);
        Get.snackbar('Error', error.message);
      },
    );
    setLoading(false);
  }

  Future<void> createTodo(String title, {int userId = 1}) async {
    setLoading(true);
    final result = await createTodoUseCase(title: title, userId: userId);
    result.when(
      success: (todo) {
        items.insert(0, todo);
        Get.snackbar('Success', 'Todo created successfully');
      },
      failure: (error) {
        setError(error.message);
        Get.snackbar('Error', error.message);
      },
    );
    setLoading(false);
  }

  Future<void> updateTodo(Todo todo) async {
    setLoading(true);
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    final result = await updateTodoUseCase(updated);
    result.when(
      success: (todo) {
        final index = items.indexWhere((t) => t.id == todo.id);
        if (index != -1) items[index] = todo;
        Get.snackbar('Success', 'Todo updated successfully');
      },
      failure: (error) {
        setError(error.message);
        Get.snackbar('Error', error.message);
      },
    );
    setLoading(false);
  }

  Future<void> deleteTodo(String id) async {
    setLoading(true);
    final result = await deleteTodoUseCase(id);
    result.when(
      success: (_) {
        items.removeWhere((t) => t.id == id);
        Get.snackbar('Success', 'Todo deleted successfully');
      },
      failure: (error) {
        setError(error.message);
        Get.snackbar('Error', error.message);
      },
    );
    setLoading(false);
  }

  void toggleTodo(Todo todo) async {
    setLoading(true);
    final result = await toggleTodoUseCase(todo.id);
    result.when(
      success: (todo) {
        final index = items.indexWhere((t) => t.id == todo.id);
        if (index != -1) items[index] = todo;
        Get.snackbar('Success', 'Todo updated successfully');
      },
      failure: (error) {
        setError(error.message);
        Get.snackbar('Error', error.message);
      },
    );
    setLoading(false);
  }
}

