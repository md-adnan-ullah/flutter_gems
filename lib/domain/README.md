# Domain Layer - Feature-Based Structure

This directory contains the domain layer organized by features following Clean Architecture principles.

## Structure

```
domain/
├── todo/                          # Todo feature
│   ├── usecases/                 # Business logic (only for complex operations)
│   │   ├── create_todo_usecase.dart  # Has validation logic
│   │   └── toggle_todo_usecase.dart  # Has get+update logic
│   │
│   └── [Note: Simple CRUD uses repository directly]
│       - getAllTodos() → repository.getAllTodos()
│       - updateTodo() → repository.updateTodo()
│       - deleteTodo() → repository.deleteTodo()
│
└── [other_features]/             # Other features follow same pattern
    └── usecases/                 # Only for operations with business logic
```

## Principles

1. **Feature-Based**: Each feature has its own folder
2. **No Dependencies**: Domain layer has NO dependencies on external frameworks
3. **Pure Business Logic**: Contains only business rules and logic
4. **Use Cases Only When Needed**: Use cases only for operations with business logic
5. **Simple CRUD**: Use repository directly for simple get/update/delete operations

## Adding a New Feature

1. Create feature folder: `domain/[feature_name]/`
2. Add use cases **only for operations with business logic**: `usecases/[action]_usecase.dart`
3. Add DI setup: `[feature]_di.dart`
4. Register in `AppServices.initialize()`: `await setup[Feature]DomainServices()`
5. Use repository directly for simple CRUD operations

## Usage

### In AppServices
```dart
await setupTodoDomainServices();
```

### In Controllers

**For simple CRUD (use repository directly):**
```dart
final repository = AppServices.getIt<TodoRepository>();
final result = await repository.getAllTodos();
```

**For operations with business logic (use use case):**
```dart
final useCase = AppServices.getIt<CreateTodoUseCase>();
final result = await useCase(title: 'New Todo');
```

## Benefits

- ✅ **Feature Isolation**: Each feature is self-contained
- ✅ **Scalable**: Easy to add new features
- ✅ **Maintainable**: Clear feature boundaries
- ✅ **Testable**: Easy to test features in isolation
- ✅ **Reusable**: Business logic can be reused
