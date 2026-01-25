import 'package:get_it/get_it.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import '../../repositories/todo_repository.dart';
import '../../domain/usecases/todo/create_todo_usecase.dart';
import '../../domain/usecases/todo/toggle_todo_usecase.dart';
import '../../controllers/todo_controller.dart';

/// Setup Todo domain services
/// Simple CRUD operations use repository directly
/// Use cases only for operations with business logic
Future<void> setupTodoDomainServices() async {
  final getIt = GetIt.instance;
  
  // Register repository (used directly for simple CRUD)
  DIHelper.registerRepository<TodoRepository>(
    factory: () => TodoRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  // Register use cases (only for operations with business logic)
  DIHelper.registerUseCase<CreateTodoUseCase, TodoRepository>(
    factory: (repo) => CreateTodoUseCase(repo),
  );

  DIHelper.registerUseCase<ToggleTodoUseCase, TodoRepository>(
    factory: (repo) => ToggleTodoUseCase(repo),
  );

  // Register controller using DIHelper
  DIHelper.registerController<TodoController>(
    factory: () => TodoController(
      repository: getIt<TodoRepository>(),
      createTodoUseCase: getIt<CreateTodoUseCase>(),
      toggleTodoUseCase: getIt<ToggleTodoUseCase>(),
    ),
  );
}

