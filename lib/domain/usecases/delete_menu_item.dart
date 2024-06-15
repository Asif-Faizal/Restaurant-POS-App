import '../../data/repositories/menu_repository.dart';

class DeleteMenuItem {
  final MenuRepository repository;

  DeleteMenuItem({required this.repository});

  Future<void> call(int tableId, int foodId, String extrasName) {
    return repository.deleteMenuItem(tableId, foodId, extrasName);
  }
}
