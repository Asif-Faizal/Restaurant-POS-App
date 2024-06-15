import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders();
}

class OrderRepositoryImpl implements OrderRepository {
  final http.Client _httpClient;
  final String baseUrl;

  OrderRepositoryImpl({required http.Client httpClient, required this.baseUrl})
      : _httpClient = httpClient;

  @override
  Future<List<Order>> fetchOrders() async {
    final response = await _httpClient.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
