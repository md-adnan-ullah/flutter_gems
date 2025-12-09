import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gems_responsive/gems_responsive.dart';
import '../controllers/todo_controller.dart';
import '../models/todo/todo_model.dart';
import '../domain/usecases/todo/get_todos_usecase.dart';
import '../domain/usecases/todo/create_todo_usecase.dart';
import '../domain/usecases/todo/update_todo_usecase.dart';
import '../domain/usecases/todo/delete_todo_usecase.dart';
import '../domain/usecases/todo/toggle_todo_usecase.dart';
import '../services/app_services.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get use cases from get_it
    final controller = Get.put(TodoController(
      getTodosUseCase: AppServices.getIt<GetTodosUseCase>(),
      createTodoUseCase: AppServices.getIt<CreateTodoUseCase>(),
      updateTodoUseCase: AppServices.getIt<UpdateTodoUseCase>(),
      deleteTodoUseCase: AppServices.getIt<DeleteTodoUseCase>(),
      toggleTodoUseCase: AppServices.getIt<ToggleTodoUseCase>(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => Text(
            'Todo App',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize:
                        ResponsiveHelper.getResponsiveFontSize(context, 14),
                  ),
                ),
                ResponsiveHelper.getResponsiveSpacing(context, 16),
                ElevatedButton(
                  onPressed: () => controller.refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.items.isEmpty) {
          return Center(
            child: Builder(
              builder: (context) => Text(
                'No todos yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refresh(),
          child: ListView.builder(
            padding: ResponsiveHelper.getResponsivePadding(context, all: 8),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final todo = controller.items[index];
              return _TodoItem(
                todo: todo,
                onToggle: () => controller.toggleTodo(todo),
                onDelete: () => controller.deleteTodo(todo.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, TodoController controller) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Enter todo title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                controller.createTodo(
                  titleController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: ResponsiveHelper.getResponsiveMargin(
        context,
        vertical: 4,
        horizontal: 8,
      ),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          'User ID: ${todo.userId}',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Todo'),
                content: Text('Are you sure you want to delete "${todo.title}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

