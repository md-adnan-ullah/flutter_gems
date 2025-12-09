import 'package:get_it/get_it.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import '../../../repositories/todo_repository.dart';
import '../../repositories/todo/todo_repository_interface.dart';
import '../../usecases/todo/get_todos_usecase.dart';
import '../../usecases/todo/create_todo_usecase.dart';
import '../../usecases/todo/update_todo_usecase.dart';
import '../../usecases/todo/delete_todo_usecase.dart';
import '../../usecases/todo/toggle_todo_usecase.dart';

/// Setup Todo domain services
Future<void> setupTodoDomainServices() async {
  final getIt = GetIt.instance;
  
  // Register repository
  if (!getIt.isRegistered<ITodoRepository>()) {
    getIt.registerLazySingleton<ITodoRepository>(
      () => TodoRepository(
        apiService: getIt<ApiService>(),
        databaseService: getIt<DatabaseService>(),
        syncService: getIt<SyncService>(),
      ),
    );
  }

  // Register use cases
  if (!getIt.isRegistered<GetTodosUseCase>()) {
    getIt.registerLazySingleton<GetTodosUseCase>(
      () => GetTodosUseCase(getIt<ITodoRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateTodoUseCase>()) {
    getIt.registerLazySingleton<CreateTodoUseCase>(
      () => CreateTodoUseCase(getIt<ITodoRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateTodoUseCase>()) {
    getIt.registerLazySingleton<UpdateTodoUseCase>(
      () => UpdateTodoUseCase(getIt<ITodoRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteTodoUseCase>()) {
    getIt.registerLazySingleton<DeleteTodoUseCase>(
      () => DeleteTodoUseCase(getIt<ITodoRepository>()),
    );
  }

  if (!getIt.isRegistered<ToggleTodoUseCase>()) {
    getIt.registerLazySingleton<ToggleTodoUseCase>(
      () => ToggleTodoUseCase(getIt<ITodoRepository>()),
    );
  }
}

