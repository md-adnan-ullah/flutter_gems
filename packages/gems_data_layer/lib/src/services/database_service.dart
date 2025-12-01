import 'package:hive_flutter/hive_flutter.dart';

/// Database Service using Hive
/// Provides local database storage for offline support
class DatabaseService {
  static const String _defaultBoxName = 'gems_database';
  Box? _defaultBox;
  final Map<String, Box> _boxes = {};

  /// Initialize database
  Future<void> initialize({String? boxName}) async {
    await Hive.initFlutter();
    _defaultBox = await Hive.openBox(boxName ?? _defaultBoxName);
  }

  /// Open a named box
  Future<Box> openBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName]!;
    }
    final box = await Hive.openBox(boxName);
    _boxes[boxName] = box;
    return box;
  }

  /// Get default box
  Box get box {
    if (_defaultBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _defaultBox!;
  }

  /// Save data to database
  Future<void> save<T>(String key, T value, {String? boxName}) async {
    final targetBox = boxName != null ? await openBox(boxName) : box;
    await targetBox.put(key, value);
  }

  /// Get data from database
  T? get<T>(String key, {String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return null;
    return targetBox.get(key) as T?;
  }

  /// Get all keys
  Iterable<dynamic> getAllKeys({String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return [];
    return targetBox.keys;
  }

  /// Get all values
  Iterable<dynamic> getAllValues({String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return [];
    return targetBox.values;
  }

  /// Get all entries as map
  Map<dynamic, dynamic> getAll({String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return {};
    return targetBox.toMap();
  }

  /// Check if key exists
  bool containsKey(String key, {String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return false;
    return targetBox.containsKey(key);
  }

  /// Delete data from database
  Future<void> delete(String key, {String? boxName}) async {
    final targetBox = boxName != null ? await openBox(boxName) : box;
    await targetBox.delete(key);
  }

  /// Delete multiple keys
  Future<void> deleteAll(List<String> keys, {String? boxName}) async {
    final targetBox = boxName != null ? await openBox(boxName) : box;
    await targetBox.deleteAll(keys);
  }

  /// Clear all data in a box
  Future<void> clear({String? boxName}) async {
    final targetBox = boxName != null ? await openBox(boxName) : box;
    await targetBox.clear();
  }

  /// Close a box
  Future<void> closeBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }

  /// Close all boxes
  Future<void> closeAll() async {
    await Future.wait(_boxes.values.map((box) => box.close()));
    _boxes.clear();
    if (_defaultBox != null) {
      await _defaultBox!.close();
      _defaultBox = null;
    }
  }

  /// Get box size
  int getBoxSize({String? boxName}) {
    final targetBox = boxName != null ? _boxes[boxName] : box;
    if (targetBox == null) return 0;
    return targetBox.length;
  }

  /// Register Hive adapter for custom types
  void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}

