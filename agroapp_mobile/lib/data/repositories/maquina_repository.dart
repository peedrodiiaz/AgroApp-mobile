import 'dart:convert';

import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/data/models/maquina_model.dart';

class MaquinaRepository {
  final ApiClient apiClient;

  MaquinaRepository(this.apiClient);

  Future<List<Maquina>> getMaquinas() async {
    try {
      final response = await apiClient.get('/api/maquinas');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        List<dynamic> maquinaListJson;
        if (decoded is List) {
          maquinaListJson = decoded;
        } else if (decoded is Map<String, dynamic>) {
          maquinaListJson = (decoded['content'] ??
                  decoded['data'] ??
                  decoded['maquinas'] ??
                  []) as List<dynamic>;
        } else {
          maquinaListJson = [];
        }
        return maquinaListJson.map((json) => Maquina.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener máquinas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener máquinas: $e');
    }
  }

  Future<Maquina> getMaquinaById(int id) async {
    try {
      final response = await apiClient.get('/api/maquinas/$id');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> maquinaJson = jsonDecode(response.body);
        return Maquina.fromJson(maquinaJson);
      } else {
        throw Exception('Error al obtener máquina: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener máquina: $e');
    }
  }
}
