import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../../repositories/todo_repository.dart';

class ToggleTodoUseCase {
  final TodoRepository repository;
  ToggleTodoUseCase(this.repository);
  
  Future<Result<Todo>> call(String id) async {
    if (id.isEmpty) return Result.failure(ValidationError(message: 'ID required'));
    final result = await repository.getTodoById(id);
    if (result.isFailure) return Result.failure(result.error!);
    return repository.updateTodo(result.value!.copyWith(isCompleted: !result.value!.isCompleted));
  }
}

