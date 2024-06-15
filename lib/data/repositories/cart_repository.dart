import 'package:http/http.dart' as http;
import 'dart:convert';

class CartRepository {
  final String baseUrl;

  CartRepository({required this.baseUrl});

  Future<void> addToCart(Map<String, dynamic> cartItem) async {
    final url = Uri.parse('$baseUrl/cart-add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartItem),
    );

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add item to cart');
    }
  }
}
