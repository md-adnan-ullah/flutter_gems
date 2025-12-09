import 'package:get_it/get_it.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import '../../repositories/todo_repository.dart';
import '../../domain/repositories/todo/todo_repository_interface.dart';
import '../../domain/usecases/todo/get_todos_usecase.dart';
import '../../domain/usecases/todo/create_todo_usecase.dart';
import '../../domain/usecases/todo/update_todo_usecase.dart';
import '../../domain/usecases/todo/delete_todo_usecase.dart';
import '../../domain/usecases/todo/toggle_todo_usecase.dart';

/// Setup Todo domain services (simplified with DIHelper)
Future<void> setupTodoDomainServices() async {
  final getIt = GetIt.instance;
  
  // Register repository
  DIHelper.registerRepository<ITodoRepository>(
    factory: () => TodoRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  // Register use cases
  DIHelper.registerUseCase<GetTodosUseCase, ITodoRepository>(
    factory: (repo) => GetTodosUseCase(repo),
  );

  DIHelper.registerUseCase<CreateTodoUseCase, ITodoRepository>(
    factory: (repo) => CreateTodoUseCase(repo),
  );

  DIHelper.registerUseCase<UpdateTodoUseCase, ITodoRepository>(
    factory: (repo) => UpdateTodoUseCase(repo),
  );

  DIHelper.registerUseCase<DeleteTodoUseCase, ITodoRepository>(
    factory: (repo) => DeleteTodoUseCase(repo),
  );

  DIHelper.registerUseCase<ToggleTodoUseCase, ITodoRepository>(
    factory: (repo) => ToggleTodoUseCase(repo),
  );
}

