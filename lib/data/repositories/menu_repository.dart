import '../providers/menu_api_providers.dart';

class MenuRepository {
  final MenuApiProvider apiProvider;

  MenuRepository({required this.apiProvider});

  Future<List<dynamic>> getMenuItems(int tableId) {
    return apiProvider.fetchMenuItems(tableId);
  }

  Future<void> deleteMenuItem(int tableId, int foodId, String extrasName) {
    return apiProvider.deleteMenuItem(tableId, foodId, extrasName);
  }
}
