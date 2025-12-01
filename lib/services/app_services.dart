import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// App Services Singleton
class AppServices {
  static AppServices? _instance;
  static AppServices get instance => _instance ??= AppServices._();

  AppServices._();

  late ApiService apiService;
  late CacheService cacheService;
  late SyncService syncService;
  late AuthService authService;
  late DatabaseService databaseService;

  /// Initialize all services
  Future<void> initialize() async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Configure API (using JSONPlaceholder for demo)
    final apiConfig = ApiConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      enableLogging: true,
      timeout: const Duration(seconds: 30),
    );

    // Create services
    apiService = ApiService(apiConfig);
    cacheService = CacheService(prefs);
    databaseService = DatabaseService();
    final connectivity = Connectivity();
    syncService = SyncService(apiService, cacheService, connectivity);
    authService = AuthService(apiService, prefs);

    // Initialize services
    await databaseService.initialize();
    await cacheService.initialize();
    await syncService.initialize();
    await authService.initialize();
  }
}

