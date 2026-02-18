import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class ApiClient {
  
  static const String baseUrl = 'http://10.0.2.2:9000';
  
  final TokenManager _tokenManager;

  ApiClient(this._tokenManager);

  // GET 
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();

    final response = await http.get(
      url,
      headers: {
        
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  // POST 
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();

    final response = await http.post(
      url,
      headers: {
        
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  // PUT 
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();

    final response = await http.put(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  // DELETE 
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();

    final response = await http.delete(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}
