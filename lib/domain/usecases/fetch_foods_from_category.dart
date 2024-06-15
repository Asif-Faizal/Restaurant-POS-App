import '../../data/models/food_model.dart';
import '../../data/repositories/food_repository.dart';

class FetchFoodsByCategory {
  final FoodRepository repository;

  FetchFoodsByCategory(this.repository);

  Future<List<Food>> call(int categoryId) {
    return repository.fetchFoodsByCategory(categoryId);
  }
}
