# Domain Layer - Feature-Based Structure

This directory contains the domain layer organized by features following Clean Architecture principles.

## Structure

```
domain/
├── todo/                          # Todo feature
│   ├── repositories/              # Repository interfaces
│   │   └── todo_repository_interface.dart
│   ├── usecases/                 # Business logic
│   │   ├── get_todos_usecase.dart
│   │   ├── create_todo_usecase.dart
│   │   ├── update_todo_usecase.dart
│   │   ├── delete_todo_usecase.dart
│   │   └── toggle_todo_usecase.dart
│   └── todo_di.dart              # Dependency injection setup
│
└── [other_features]/             # Other features follow same pattern
    ├── repositories/
    ├── usecases/
    └── [feature]_di.dart
```

## Principles

1. **Feature-Based**: Each feature has its own folder
2. **No Dependencies**: Domain layer has NO dependencies on external frameworks
3. **Pure Business Logic**: Contains only business rules and logic
4. **Interfaces**: Defines contracts that data layer must implement
5. **Use Cases**: Single responsibility business operations

## Adding a New Feature

1. Create feature folder: `domain/[feature_name]/`
2. Add repository interface: `repositories/[feature]_repository_interface.dart`
3. Add use cases: `usecases/[action]_usecase.dart`
4. Add DI setup: `[feature]_di.dart`
5. Register in `AppServices.initialize()`: `await setup[Feature]DomainServices()`

## Usage

### In AppServices
```dart
await setupTodoDomainServices();
```

### In Controllers
```dart
final useCase = AppServices.getIt<GetTodosUseCase>();
final result = await useCase();
```

## Benefits

- ✅ **Feature Isolation**: Each feature is self-contained
- ✅ **Scalable**: Easy to add new features
- ✅ **Maintainable**: Clear feature boundaries
- ✅ **Testable**: Easy to test features in isolation
- ✅ **Reusable**: Business logic can be reused
