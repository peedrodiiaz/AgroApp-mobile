import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class ApiClient {
  
  static const String baseUrl = 'http://10.0.2.2:9000';
  
  final TokenManager _tokenManager;

  ApiClient(this._tokenManager);

  Map<String, String> _headers({String? token, bool hasBody = false}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();
    return http.get(url, headers: _headers(token: token));
  }

  // POST
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();
    return http.post(
      url,
      headers: _headers(token: token, hasBody: true),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // PUT
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();
    return http.put(
      url,
      headers: _headers(token: token, hasBody: true),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();
    return http.delete(url, headers: _headers(token: token));
  }
}
