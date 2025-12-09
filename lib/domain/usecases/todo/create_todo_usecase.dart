import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class CreateTodoUseCase {
  final ITodoRepository repository;
  CreateTodoUseCase(this.repository);
  
  Future<Result<Todo>> call({required String title, int userId = 1}) async {
    final validation = FormValidator.validateField(
      value: title,
      rules: [
        StringValidators.required(),
        StringValidators.minLength(1),
        StringValidators.maxLength(200),
      ],
    );
    if (validation.isFailure) return Result.failure(validation.error!);
    
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      isCompleted: false,
      userId: userId,
    );
    return repository.createTodo(todo);
  }
}

