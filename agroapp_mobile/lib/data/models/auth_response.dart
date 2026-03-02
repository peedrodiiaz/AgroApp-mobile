import 'package:agroapp_mobile/data/models/trabajador_response.dart';

class AuthResponse {
  final String token;
  final String refreshToken;
  final Trabajador? user;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: json['user'] != null ? Trabajador.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user,
    };
  }
}
