/// Flutter Gems Data Layer Package
///
/// A comprehensive data layer package with REST API, CRUD operations,
/// authentication, GetX state management, and offline/online support.
library gems_data_layer;

// Services
export 'src/services/api_service.dart';
export 'src/services/auth_service.dart';
export 'src/services/cache_service.dart';
export 'src/services/sync_service.dart';
export 'src/services/database_service.dart';

// Controllers
export 'src/controllers/base_controller.dart';

// Repositories
export 'src/repositories/base_repository.dart';

// Models
export 'src/models/base_model.dart';

// Utils
export 'src/utils/api_config.dart';
export 'src/utils/api_response.dart';
