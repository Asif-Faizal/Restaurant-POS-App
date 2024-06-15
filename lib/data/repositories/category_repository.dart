import 'package:ballast_machn_test/data/models/category_model.dart';
import 'package:ballast_machn_test/data/providers/category_api_provider.dart';

class CategoryRepository {
  final CategoryApiProvider apiProvider;

  CategoryRepository({required this.apiProvider});

  Future<List<CategoryModel>> getCategories() async {
    return await apiProvider.fetchCategories();
  }
}
