import 'dart:convert';

import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';
import 'package:flutter/foundation.dart';

class AsignacionRepository {
  final ApiClient apiClient;

  AsignacionRepository(this.apiClient);

  Future<List<Asignacion>> getMisAsignaciones() async {
    final response = await apiClient.get('/api/asignaciones');
    debugPrint('MIS-ASIGNACIONES status: ${response.statusCode}');
    debugPrint('MIS-ASIGNACIONES body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> asignacionListJson = _extractList(decoded);
      return asignacionListJson.map((json) => Asignacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener asignaciones: ${response.statusCode}');
    }
  }

  Future<List<Asignacion>> getAsignaciones() async {
    final response = await apiClient.get('/api/asignaciones');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> jsonList = _extractList(decoded);
      return jsonList.map((json) => Asignacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener asignaciones: ${response.statusCode}');
    }
  }

  Future<List<Asignacion>> getByMaquina(int maquinaId) async {
    final response = await apiClient.get('/api/asignaciones');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> jsonList = _extractList(decoded);
      return jsonList
          .map((json) => Asignacion.fromJson(json))
          .where((a) => a.maquina.id == maquinaId)
          .toList();
    } else {
      throw Exception('Error al obtener asignaciones: ${response.statusCode}');
    }
  }

  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final value = decoded['content'] ??
          decoded['data'] ??
          decoded['asignaciones'];
      if (value is List) return value;
      return [];
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
        'trabajadorId': 0,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      String mensaje = 'Error al crear la reserva (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          mensaje =
              body['message'] ??
              body['mensaje'] ??
              body['error'] ??
              body['detail'] ??
              mensaje;
        } else if (body is String && body.isNotEmpty) {
          mensaje = body;
        }
      } catch (_) {}
      throw Exception(mensaje);
    }
  }
}
