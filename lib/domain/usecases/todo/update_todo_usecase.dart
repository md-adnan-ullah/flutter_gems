import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class UpdateTodoUseCase {
  final ITodoRepository repository;
  UpdateTodoUseCase(this.repository);
  
  Future<Result<Todo>> call(Todo todo) async {
    final validation = FormValidator.validateField(
      value: todo.title,
      rules: [StringValidators.required(), StringValidators.minLength(1)],
    );
    if (validation.isFailure) return Result.failure(validation.error!);
    return repository.updateTodo(todo);
  }
}

