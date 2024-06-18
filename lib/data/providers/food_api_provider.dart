import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class FoodApiProvider {
  final String _baseUrl = 'http://10.0.2.2:3000/api/mainstockdupe';

  Future<List<Food>> fetchFoodsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/category/$category'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load food data');
    }
  }
}
