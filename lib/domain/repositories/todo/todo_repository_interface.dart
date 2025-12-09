import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';

/// Repository interface for Todo domain
abstract class ITodoRepository {
  Future<Result<List<Todo>>> getAllTodos();
  Future<Result<Todo>> getTodoById(String id);
  Future<Result<Todo>> createTodo(Todo todo);
  Future<Result<Todo>> updateTodo(Todo todo);
  Future<Result<void>> deleteTodo(String id);
}

