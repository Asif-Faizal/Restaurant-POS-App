import '../../data/models/food_model.dart';
import '../../data/repositories/food_repository.dart';

class FetchFoodUseCase {
  final FoodRepository repository;

  FetchFoodUseCase(this.repository);

  Future<List<Food>> execute(String category) {
    return repository.getFoodsByCategory(category);
  }
}
