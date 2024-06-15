import '../../data/repositories/menu_repository.dart';

class FetchMenuItems {
  final MenuRepository repository;

  FetchMenuItems({required this.repository});

  Future<List<dynamic>> call(int tableId) {
    return repository.getMenuItems(tableId);
  }
}
