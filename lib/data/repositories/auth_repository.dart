import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String apiUrl = 'http://10.0.2.2:3000/login';

  Future<bool> authenticate(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody.containsKey('authenticated')) {
            return responseBody['authenticated'] ?? false;
          } else {
            throw Exception('Invalid response format');
          }
        } catch (_) {
          return true;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to authenticate: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during authentication: $error');
      rethrow;
    }
  }
}
