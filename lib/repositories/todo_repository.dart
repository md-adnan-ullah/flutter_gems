import 'package:gems_data_layer/gems_data_layer.dart';
import '../models/todo_model.dart';

class TodoRepository extends BaseRepository<Todo> {
  TodoRepository({
    required super.apiService,
    required super.cacheService,
    required super.syncService,
  }) : super(baseEndpoint: '/todos');

  @override
  Todo fromJson(Map<String, dynamic> json) => Todo.fromJson(json);

  @override
  Map<String, dynamic> toJson(Todo model) => model.toJson();
}

