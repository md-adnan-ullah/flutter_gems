import 'package:gems_core/gems_core.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class DeleteTodoUseCase {
  final ITodoRepository repository;
  DeleteTodoUseCase(this.repository);
  
  Future<Result<void>> call(String id) async {
    if (id.isEmpty) return Result.failure(ValidationError(message: 'ID required'));
    return await repository.deleteTodo(id);
  }
}

