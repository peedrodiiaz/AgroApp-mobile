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
        final decoded = jsonDecode(response.body);
        final List<dynamic> asignacionListJson = _extractList(decoded);
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
        final decoded = jsonDecode(response.body);
        final List<dynamic> jsonList = _extractList(decoded);
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

  Future<List<Asignacion>> getByMaquina(int maquinaId) async {
    try {
      final response = await apiClient.get('/api/asignaciones/maquina/$maquinaId');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> jsonList = _extractList(decoded);
        return jsonList.map((json) => Asignacion.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener asignaciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      return (decoded['content'] ??
          decoded['data'] ??
          decoded['asignaciones'] ??
          []) as List<dynamic>;
    }
    return [];
  }

  Future<void> createAsignacion({
    required String fechaInicio,
    required String fechaFin,
    required String descripcion,
    required int maquinaId,
  }) async {
    final response = await apiClient.post(
      '/api/asignaciones',
      body: {
        'fechaInicio': fechaInicio,
        'fechaFin': fechaFin,
        'descripcion': descripcion,
        'maquinaId': maquinaId,
        'trabajadorId': 0, // el backend lo saca del token
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear asignación: ${response.statusCode}');
    }
  }
}
