import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ballast_machn_test/data/models/category_model.dart';

class CategoryApiProvider {
  final String apiUrl = 'http://10.0.2.2:3000/category';

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
