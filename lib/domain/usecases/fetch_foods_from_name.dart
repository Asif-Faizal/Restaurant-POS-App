import '../../data/models/food_model.dart';
import '../../data/repositories/food_repository.dart';

class FetchFoodsByName {
  final FoodRepository repository;

  FetchFoodsByName(this.repository);

  Future<Food> call(String name) {
    return repository.fetchFoodsByName(name);
  }
}
