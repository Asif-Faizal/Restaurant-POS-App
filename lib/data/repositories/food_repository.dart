import '../models/food_model.dart';
import '../providers/food_api_provider.dart';

class FoodRepository {
  final FoodApiProvider _apiProvider = FoodApiProvider();

  Future<List<Food>> getFoodsByCategory(String category) {
    return _apiProvider.fetchFoodsByCategory(category);
  }
}
