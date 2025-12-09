import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import '../models/todo/todo_model.dart';
import '../domain/repositories/todo/todo_repository_interface.dart';

class TodoRepository extends BaseRepository<Todo> implements ITodoRepository {
  TodoRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: '/todos');

  @override
  Todo fromJson(Map<String, dynamic> json) => Todo.fromJson(json);

  @override
  Future<Result<List<Todo>>> getAllTodos() async {
    try {
      final response = await getAll(useCache: true);
      if (response.success && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ApiError(message: response.message ?? 'Failed to load todos'));
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<Todo>> getTodoById(String id) async {
    try {
      final response = await getById(id, useCache: true);
      if (response.success && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ApiError(message: response.message ?? 'Todo not found'));
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<Todo>> createTodo(Todo todo) async {
    try {
      final response = await create(todo, syncOffline: true);
      if (response.success && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ApiError(message: response.message ?? 'Failed to create todo'));
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<Todo>> updateTodo(Todo todo) async {
    try {
      final response = await update(todo.id, todo, syncOffline: true);
      if (response.success && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ApiError(message: response.message ?? 'Failed to update todo'));
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    try {
      final response = await delete(id, syncOffline: true);
      if (response.success) return Result.success(null);
      return Result.failure(ApiError(message: response.message ?? 'Failed to delete todo'));
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }
}

