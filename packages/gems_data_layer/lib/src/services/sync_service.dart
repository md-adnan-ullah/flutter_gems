import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'api_service.dart';
import 'cache_service.dart';
import '../utils/api_response.dart';

/// Sync queue item
class SyncItem {
  final String id;
  final String method; // GET, POST, PUT, DELETE, PATCH
  final String endpoint;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final DateTime timestamp;
  final String? modelType; // For identifying which model to sync

  SyncItem({
    required this.id,
    required this.method,
    required this.endpoint,
    this.data,
    this.queryParameters,
    required this.timestamp,
    this.modelType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'endpoint': endpoint,
      'data': data,
      'queryParameters': queryParameters,
      'timestamp': timestamp.toIso8601String(),
      'modelType': modelType,
    };
  }

  factory SyncItem.fromJson(Map<String, dynamic> json) {
    return SyncItem(
      id: json['id'] as String,
      method: json['method'] as String,
      endpoint: json['endpoint'] as String,
      data: json['data'],
      queryParameters: json['queryParameters'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      modelType: json['modelType'] as String?,
    );
  }
}

/// Background Sync Service
class SyncService {
  final ApiService apiService;
  final CacheService cacheService;
  final Connectivity connectivity;
  static const String _syncQueueKey = 'sync_queue';
  static const String _syncTaskName = 'gems_sync_task';

  SyncService(this.apiService, this.cacheService, this.connectivity);

  /// Initialize background sync
  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    // Register periodic sync task (runs every 15 minutes)
    await Workmanager().registerPeriodicTask(
      _syncTaskName,
      _syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  /// Add item to sync queue
  Future<void> addToQueue(SyncItem item) async {
    final queue = await getQueue();
    queue.add(item);
    await _saveQueue(queue);
  }

  /// Get sync queue
  Future<List<SyncItem>> getQueue() async {
    final queueJson = await cacheService.get<List<dynamic>>(
      _syncQueueKey,
      (data) => data as List<dynamic>,
    );

    if (queueJson == null) return [];

    return queueJson
        .map((item) => SyncItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Sync queue (call this when online)
  Future<void> syncQueue() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      // connectivity_plus 5.x returns a single ConnectivityResult
      if (connectivityResult == ConnectivityResult.none) {
        return; // No internet, skip sync
      }
    } catch (e) {
      // If checkConnectivity fails, assume no connection
      return;
    }

    final queue = await getQueue();
    if (queue.isEmpty) return;

    final List<SyncItem> failedItems = [];

    for (final item in queue) {
      try {
        ApiResponse response;

        switch (item.method.toUpperCase()) {
          case 'GET':
            response = await apiService.get(
              item.endpoint,
              queryParameters: item.queryParameters,
            );
            break;
          case 'POST':
            response = await apiService.post(
              item.endpoint,
              data: item.data,
              queryParameters: item.queryParameters,
            );
            break;
          case 'PUT':
            response = await apiService.put(
              item.endpoint,
              data: item.data,
              queryParameters: item.queryParameters,
            );
            break;
          case 'PATCH':
            response = await apiService.patch(
              item.endpoint,
              data: item.data,
              queryParameters: item.queryParameters,
            );
            break;
          case 'DELETE':
            response = await apiService.delete(
              item.endpoint,
              queryParameters: item.queryParameters,
            );
            break;
          default:
            continue;
        }

        if (!response.success) {
          failedItems.add(item);
        }
      } catch (e) {
        failedItems.add(item);
      }
    }

    // Save failed items back to queue
    await _saveQueue(failedItems);
  }

  /// Clear sync queue
  Future<void> clearQueue() async {
    await cacheService.delete(_syncQueueKey);
  }

  /// Save queue to cache
  Future<void> _saveQueue(List<SyncItem> queue) async {
    await cacheService.save(
      _syncQueueKey,
      queue.map((item) => item.toJson()).toList(),
    );
  }
}

/// Background callback dispatcher (must be top-level)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize services here
    // Then call syncQueue()
    return Future.value(true);
  });
}

