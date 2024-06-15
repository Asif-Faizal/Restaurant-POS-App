import 'package:ballast_machn_test/data/repositories/category_repository.dart';
import 'package:ballast_machn_test/domain/entities/category.dart';

class FetchCategories {
  final CategoryRepository repository;

  FetchCategories({required this.repository});

  Future<List<Category>> call() async {
    final categories = await repository.getCategories();
    return categories
        .map((category) => Category(
              id: category.id,
              name: category.name,
              imageUrl: category.imageUrl,
            ))
        .toList();
  }
}
