import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuApiProvider {
  final String baseUrl;

  MenuApiProvider({required this.baseUrl});

  Future<List<dynamic>> fetchMenuItems(int tableId) async {
    final response = await http.get(Uri.parse('$baseUrl/cart/$tableId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> deleteMenuItem(
      int tableId, int foodId, String extrasName) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart-remove/$tableId/$foodId/$extrasName'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete menu item');
    }
  }
}
