import 'dart:convert';

import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';

class AsignacionRepository {
  final ApiClient apiClient;

  AsignacionRepository(this.apiClient);

  Future<List<Asignacion>> getMisAsignaciones() async {
    try {
      final response = await apiClient.get(
        '/api/asignaciones/mis-asignaciones',
      );
      if (response.statusCode == 200) {
        final List<dynamic> asignacionListJson = jsonDecode(response.body);
        return asignacionListJson
            .map((json) => Asignacion.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Error al obtener asignaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener asignaciones: $e');
    }
  }

  Future<List<Asignacion>> getAsignaciones() async {
    try {
      final response = await apiClient.get('/api/asignaciones');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Asignacion.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener asignaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
