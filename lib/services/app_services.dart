import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:gems_core/gems_core.dart';
import 'package:get_it/get_it.dart';
import '../di/todo/todo_di.dart';

/// App Services using get_it for dependency injection
class AppServices {
  static final getIt = GetIt.instance;

  /// Initialize all services using get_it
  /// This sets up gems_core, gems_data_layer, gems_responsive, and domain services
  Future<void> initialize({
    EnvironmentMode environmentMode = EnvironmentMode.development,
    AppConfig? appConfig,
  }) async {
    // Setup gems_core services (environment, config)
    await setupCoreServices(
      environmentMode: environmentMode,
      config: appConfig,
    );

    // Get environment config
    final env = Environment.instance;
    
    // Configure API using environment config
    final apiConfig = ApiConfig(
      baseUrl: env.apiBaseUrl,
      enableLogging: env.enableLogging,
      timeout: env.apiTimeout,
    );

    // Setup gems_data_layer services
    await setupDataLayerServices(
      apiConfig: apiConfig,
    );

    // Setup gems_responsive services
    setupResponsiveServices();

    // Setup domain layer services (feature-wise)
    await setupTodoDomainServices();

    // All services are now registered in get_it and can be accessed via:
    // AppServices.getIt<ApiService>()
    // AppServices.getIt<DatabaseService>()
    // AppServices.getIt<SyncService>()
    // AppServices.getIt<AuthService>()
    // AppServices.getIt<Environment>()
    // AppServices.getIt<GetTodosUseCase>()
    // AppServices.getIt<CreateTodoUseCase>()
    // etc.
  }

  /// Convenience getters for easy access to services
  ApiService get apiService => getIt<ApiService>();
  SyncService get syncService => getIt<SyncService>();
  AuthService get authService => getIt<AuthService>();
  DatabaseService get databaseService => getIt<DatabaseService>();

  /// Reset all services (useful for testing)
  Future<void> reset() async {
    await getIt.reset(); // Reset all registered services
    await resetCoreServices();
    await resetDataLayerServices();
    await resetResponsiveServices();
  }
}

