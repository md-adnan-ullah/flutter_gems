import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class GetTodosUseCase {
  final ITodoRepository repository;
  GetTodosUseCase(this.repository);
  
  Future<Result<List<Todo>>> call() => repository.getAllTodos();
}

