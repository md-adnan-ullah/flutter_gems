import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class ToggleTodoUseCase {
  final ITodoRepository repository;
  ToggleTodoUseCase(this.repository);
  
  Future<Result<Todo>> call(String id) async {
    if (id.isEmpty) return Result.failure(ValidationError(message: 'ID required'));
    final result = await repository.getTodoById(id);
    if (result.isFailure) return Result.failure(result.error!);
    return repository.updateTodo(result.value!.copyWith(isCompleted: !result.value!.isCompleted));
  }
}

