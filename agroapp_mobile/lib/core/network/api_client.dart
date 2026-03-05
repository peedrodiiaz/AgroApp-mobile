import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class ApiClient {

  static const String baseUrl = 'http://10.0.2.2:9000';

  final TokenManager _tokenManager;
  final _unauthorizedController = StreamController<void>.broadcast();

  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  ApiClient(this._tokenManager);

  void _checkUnauthorized(http.Response response) {
    if (response.statusCode == 401) {
      _unauthorizedController.add(null);
    }
  }

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
    final response = await http.get(url, headers: _headers(token: token));
    _checkUnauthorized(response);
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
      headers: _headers(token: token, hasBody: true),
      body: body != null ? jsonEncode(body) : null,
    );
    _checkUnauthorized(response);
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
      headers: _headers(token: token, hasBody: true),
      body: body != null ? jsonEncode(body) : null,
    );
    _checkUnauthorized(response);
    return response;
  }

  // DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _tokenManager.getToken();
    final response = await http.delete(url, headers: _headers(token: token));
    _checkUnauthorized(response);
    return response;
  }

  void dispose() {
    _unauthorizedController.close();
  }
}
