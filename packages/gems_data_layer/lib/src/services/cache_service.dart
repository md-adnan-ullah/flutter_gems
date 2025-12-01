import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cache Service for offline support
class CacheService {
  final SharedPreferences prefs;
  Box? _cacheBox;
  static const String _cacheBoxName = 'gems_cache';

  CacheService(this.prefs);

  /// Initialize cache (call this before using)
  Future<void> initialize() async {
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox(_cacheBoxName);
  }

  /// Save data to cache
  Future<void> save<T>(String key, T data, {Duration? ttl}) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'ttl': ttl?.inSeconds,
    };

    if (_cacheBox != null) {
      await _cacheBox!.put(key, jsonEncode(cacheData));
    } else {
      await prefs.setString('cache_$key', jsonEncode(cacheData));
    }
  }

  /// Get data from cache
  Future<T?> get<T>(String key, T Function(dynamic)? fromJson) async {
    String? cachedJson;

    if (_cacheBox != null) {
      cachedJson = _cacheBox!.get(key) as String?;
    } else {
      cachedJson = prefs.getString('cache_$key');
    }

    if (cachedJson == null) return null;

    try {
      final cacheData = jsonDecode(cachedJson) as Map<String, dynamic>;
      
      // Check TTL
      if (cacheData['ttl'] != null) {
        final timestamp = DateTime.parse(cacheData['timestamp'] as String);
        final ttl = Duration(seconds: cacheData['ttl'] as int);
        if (DateTime.now().difference(timestamp) > ttl) {
          await delete(key);
          return null;
        }
      }

      final data = cacheData['data'];
      return fromJson != null ? fromJson(data) : data as T?;
    } catch (e) {
      return null;
    }
  }

  /// Delete from cache
  Future<void> delete(String key) async {
    if (_cacheBox != null) {
      await _cacheBox!.delete(key);
    } else {
      await prefs.remove('cache_$key');
    }
  }

  /// Clear all cache
  Future<void> clear() async {
    if (_cacheBox != null) {
      await _cacheBox!.clear();
    } else {
      final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    }
  }

  /// Check if key exists
  Future<bool> exists(String key) async {
    if (_cacheBox != null) {
      return _cacheBox!.containsKey(key);
    } else {
      return prefs.containsKey('cache_$key');
    }
  }
}

