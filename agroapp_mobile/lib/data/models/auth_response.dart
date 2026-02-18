class AuthResponse {
  final String token;
  final String refreshToken;

  AuthResponse({
    required this.token,
    required this.refreshToken,
  });

  // CConertimos el json  a objeto AuthResponse
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  // Conviertimos el AuthResponse a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
