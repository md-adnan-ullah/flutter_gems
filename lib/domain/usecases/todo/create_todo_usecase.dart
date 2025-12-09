import 'package:gems_core/gems_core.dart';
import '../../../models/todo/todo_model.dart';
import '../../repositories/todo/todo_repository_interface.dart';

class CreateTodoUseCase with ValidationMixin {
  final ITodoRepository repository;
  CreateTodoUseCase(this.repository);
  
  Future<Result<Todo>> call({required String title, int userId = 1}) async {
    final validation = validateString(
      title,
      fieldName: 'Title',
      minLength: 1,
      maxLength: 200,
    );
    if (validation.isFailure) return Result.failure(validation.error!);
    
    final todo = Todo(
      id: UseCaseHelper.generateId(prefix: 'todo'),
      title: title.trim(),
      isCompleted: false,
      userId: userId,
    );
    return repository.createTodo(todo);
  }
}

