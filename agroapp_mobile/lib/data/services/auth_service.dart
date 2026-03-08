import 'dart:convert';
import 'dart:io';
import '../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/trabajador_response.dart';

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

  Future<Trabajador?> getMe() async {
    try {
      final response = await _apiClient.get('/api/trabajadores/me');
      if (response.statusCode == 200) {
        return Trabajador.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return null;
  }

  Future<Trabajador> uploadFotoMe(File imageFile) async {
    final response = await _apiClient.putMultipart(
      '/api/trabajadores/me/foto',
      file: imageFile,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Trabajador.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al subir foto: ${response.statusCode}');
  }
}
