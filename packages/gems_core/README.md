# gems_core

Core utilities for Flutter apps - Result types, error handling, environment configuration, and input validation.

## Features

- ✅ **Result Types** - Type-safe error handling with `Result<T>`
- ✅ **Error Handling** - Comprehensive error types (Network, API, Validation, etc.)
- ✅ **Environment Configuration** - Easy environment management (dev/staging/prod)
- ✅ **Input Validation** - Reusable validation rules and form validation
- ✅ **get_it Integration** - Service locator support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  gems_core:
    path: packages/gems_core
```

## Usage

### Result Types

```dart
import 'package:gems_core/gems_core.dart';

Result<String> fetchData() {
  try {
    return Result.success('Data loaded');
  } catch (e) {
    return Result.failure(
      UnknownError(message: e.toString()),
    );
  }
}

// Use the result
final result = fetchData();
result.when(
  success: (data) => print('Success: $data'),
  failure: (error) => print('Error: ${error.message}'),
);
```

### Environment Configuration

```dart
import 'package:gems_core/gems_core.dart';

// Initialize in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupCoreServices(
    environmentMode: EnvironmentMode.development,
    config: AppConfig.development(),
  );
  
  runApp(MyApp());
}

// Use environment
final apiUrl = Environment.instance.apiBaseUrl;
final isDev = Environment.instance.isDevelopment;
```

### Input Validation

```dart
import 'package:gems_core/gems_core.dart';

// Validate single field
final emailResult = FormValidator.validateField(
  value: 'user@example.com',
  rules: [
    StringValidators.required(),
    StringValidators.email(),
  ],
);

// Validate form
final formResult = FormValidator.validateForm(
  values: {
    'email': 'user@example.com',
    'password': 'password123',
  },
  rules: {
    'email': [
      StringValidators.required(),
      StringValidators.email(),
    ],
    'password': [
      StringValidators.required(),
      StringValidators.minLength(8),
    ],
  },
);
```

## API Reference

### Result Types
- `Result<T>` - Generic result type
- `Result.success(T)` - Create success result
- `Result.failure(AppError)` - Create failure result

### Error Types
- `AppError` - Base error class
- `NetworkError` - Network related errors
- `ApiError` - API related errors
- `ValidationError` - Validation errors
- `AuthError` - Authentication errors
- `StorageError` - Storage/Database errors

### Validators
- `StringValidators` - String validation rules
- `NumberValidators` - Number validation rules
- `FormValidator` - Form validation utilities

## Author

**Md. Adnan Ullah**
- Email: saadnanullah@gmail.com
- GitHub: [md-adnan-ullah](https://github.com/md-adnan-ullah)

## License

MIT License - see LICENSE file for details

