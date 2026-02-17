import 'dart:convert';
import '../../core/network/api_client.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AuthResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Usuario o contraseña incorrectos');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
