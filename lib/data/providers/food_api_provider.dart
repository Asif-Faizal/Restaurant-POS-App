import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/food_model.dart';

class FoodApiProvider {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Food>> fetchFoodsByCategory(int categoryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/foods-query'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'categoryid': categoryId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  Future<Food> fetchFoodByName(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/foods-query'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Food.fromJson(data[0]);
      } else {
        throw Exception('Food not found');
      }
    } else {
      throw Exception('Failed to load food');
    }
  }
}
