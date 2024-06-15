import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/extras_model.dart';

class ExtraApiProvider {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Extra>> fetchExtras(int foodId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/extras-query'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'foodid': foodId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Extra.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load extras');
    }
  }
}
