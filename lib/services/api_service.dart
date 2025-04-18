import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://test.mbenki.com';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "strategy": "local",
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['accessToken'];
    } else {
      throw Exception('Login failed: ${jsonDecode(response.body)['message']}');
    }
  }

  Future<List<dynamic>> getGuests(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/guests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load guests');
    }
  }
}