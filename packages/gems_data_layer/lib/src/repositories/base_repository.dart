import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/sync_service.dart';
import '../utils/api_response.dart';

/// Base Repository class
/// Extend this class to create your own repositories
abstract class BaseRepository<T> {
  final ApiService apiService;
  final CacheService cacheService;
  final SyncService syncService;
  final String baseEndpoint;

  BaseRepository({
    required this.apiService,
    required this.cacheService,
    required this.syncService,
    required this.baseEndpoint,
  });

  /// Convert JSON to model
  T fromJson(Map<String, dynamic> json);

  /// Convert model to JSON
  Map<String, dynamic> toJson(T model);

  /// Get all items
  Future<ApiResponse<List<T>>> getAll({
    Map<String, dynamic>? queryParameters,
    bool useCache = true,
    Duration? cacheTTL,
  }) async {
    final cacheKey = '${baseEndpoint}_all';

    // Try cache first
    if (useCache) {
      final cached = await cacheService.get<List<dynamic>>(
        cacheKey,
        (data) => data as List<dynamic>,
      );
      if (cached != null) {
        return ApiResponse.success(
          cached.map((item) => fromJson(item as Map<String, dynamic>)).toList(),
        );
      }
    }

    // Fetch from API
    final response = await apiService.get<List<dynamic>>(
      baseEndpoint,
      queryParameters: queryParameters,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final items = response.data!
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache the result
      if (useCache) {
        await cacheService.save(
          cacheKey,
          items.map((item) => toJson(item)).toList(),
          ttl: cacheTTL,
        );
      }

      return ApiResponse.success(items);
    }

    return ApiResponse.error(
      response.message ?? 'Failed to fetch items',
      statusCode: response.statusCode,
    );
  }

  /// Get item by ID
  Future<ApiResponse<T>> getById(
    String id, {
    bool useCache = true,
    Duration? cacheTTL,
  }) async {
    final cacheKey = '${baseEndpoint}_$id';

    // Try cache first
    if (useCache) {
      final cached = await cacheService.get<Map<String, dynamic>>(
        cacheKey,
        (data) => data as Map<String, dynamic>,
      );
      if (cached != null) {
        return ApiResponse.success(fromJson(cached));
      }
    }

    // Fetch from API
    final response = await apiService.get<Map<String, dynamic>>(
      '$baseEndpoint/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      final item = fromJson(response.data!);

      // Cache the result
      if (useCache) {
        await cacheService.save(
          cacheKey,
          toJson(item),
          ttl: cacheTTL,
        );
      }

      return ApiResponse.success(item);
    }

    return ApiResponse.error(
      response.message ?? 'Failed to fetch item',
      statusCode: response.statusCode,
    );
  }

  /// Create item
  Future<ApiResponse<T>> create(
    T model, {
    bool syncOffline = true,
  }) async {
    final response = await apiService.post<Map<String, dynamic>>(
      baseEndpoint,
      data: toJson(model),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      final item = fromJson(response.data!);
      
      // Invalidate cache
      await cacheService.delete('${baseEndpoint}_all');

      return ApiResponse.success(item);
    }

    // If offline and sync enabled, add to queue
    if (syncOffline) {
      await syncService.addToQueue(
        SyncItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          method: 'POST',
          endpoint: baseEndpoint,
          data: toJson(model),
          timestamp: DateTime.now(),
          modelType: T.toString(),
        ),
      );
    }

    return ApiResponse.error(
      response.message ?? 'Failed to create item',
      statusCode: response.statusCode,
    );
  }

  /// Update item
  Future<ApiResponse<T>> update(
    String id,
    T model, {
    bool syncOffline = true,
  }) async {
    final response = await apiService.put<Map<String, dynamic>>(
      '$baseEndpoint/$id',
      data: toJson(model),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      final item = fromJson(response.data!);
      
      // Update cache
      await cacheService.save('${baseEndpoint}_$id', toJson(item));
      await cacheService.delete('${baseEndpoint}_all');

      return ApiResponse.success(item);
    }

    // If offline and sync enabled, add to queue
    if (syncOffline) {
      await syncService.addToQueue(
        SyncItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          method: 'PUT',
          endpoint: '$baseEndpoint/$id',
          data: toJson(model),
          timestamp: DateTime.now(),
          modelType: T.toString(),
        ),
      );
    }

    return ApiResponse.error(
      response.message ?? 'Failed to update item',
      statusCode: response.statusCode,
    );
  }

  /// Delete item
  Future<ApiResponse<bool>> delete(
    String id, {
    bool syncOffline = true,
  }) async {
    final response = await apiService.delete<bool>(
      '$baseEndpoint/$id',
    );

    if (response.success) {
      // Remove from cache
      await cacheService.delete('${baseEndpoint}_$id');
      await cacheService.delete('${baseEndpoint}_all');

      return ApiResponse.success(true);
    }

    // If offline and sync enabled, add to queue
    if (syncOffline) {
      await syncService.addToQueue(
        SyncItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          method: 'DELETE',
          endpoint: '$baseEndpoint/$id',
          timestamp: DateTime.now(),
          modelType: T.toString(),
        ),
      );
    }

    return ApiResponse.error(
      response.message ?? 'Failed to delete item',
      statusCode: response.statusCode,
    );
  }
}

