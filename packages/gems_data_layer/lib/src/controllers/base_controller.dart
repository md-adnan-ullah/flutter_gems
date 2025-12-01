import 'package:get/get.dart';
import '../utils/api_response.dart';

/// Base Controller with common state management
abstract class BaseController<T> extends GetxController {
  final Rx<ApiResponse<T?>> state = ApiResponse<T?>(success: false).obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Set loading state
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  /// Set error
  void setError(String message) {
    errorMessage.value = message;
    state.value = ApiResponse.error(message);
  }

  /// Set success data
  void setSuccess(T data) {
    errorMessage.value = '';
    state.value = ApiResponse.success(data);
  }

  /// Handle API response
  void handleResponse<R>(ApiResponse<R> response, T Function(R)? mapper) {
    setLoading(false);

    if (response.success && response.data != null) {
      if (mapper != null) {
        setSuccess(mapper(response.data as R));
      } else {
        setSuccess(response.data as T);
      }
    } else {
      setError(response.message ?? 'An error occurred');
    }
  }

  @override
  void onClose() {
    state.close();
    super.onClose();
  }
}

/// Base List Controller for managing lists
abstract class BaseListController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasMore = true.obs;
  int _page = 1;
  final int pageSize = 20;

  int get page => _page;

  /// Set loading state
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  /// Set error
  void setError(String message) {
    errorMessage.value = message;
  }

  /// Add items
  void addItems(List<T> newItems) {
    if (newItems.length < pageSize) {
      hasMore.value = false;
    }
    items.addAll(newItems);
    _page++;
  }

  /// Refresh items
  Future<void> refresh() async {
    _page = 1;
    hasMore.value = true;
    items.clear();
    await loadItems();
  }

  /// Load items (implement in child class)
  Future<void> loadItems();

  @override
  void onClose() {
    items.close();
    super.onClose();
  }
}

