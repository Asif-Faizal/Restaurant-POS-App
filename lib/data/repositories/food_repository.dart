import 'package:ballast_machn_test/data/providers/food_api_provider.dart';

import '../models/food_model.dart';

class FoodRepository {
  final FoodApiProvider apiProvider;

  FoodRepository({required this.apiProvider});

  Future<List<Food>> fetchFoodsByCategory(int categoryId) {
    return apiProvider.fetchFoodsByCategory(categoryId);
  }

  Future<Food> fetchFoodsByName(String name) {
    return apiProvider.fetchFoodByName(name);
  }
}
