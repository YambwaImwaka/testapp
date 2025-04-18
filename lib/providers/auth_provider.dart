import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null) {
    loadToken();
  }

  final ApiService _apiService = ApiService();
  
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('token');
  }

  Future<void> login(String email, String password) async {
    try {
      final token = await _apiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      state = token;
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = null;
  }
}