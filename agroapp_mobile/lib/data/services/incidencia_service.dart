import 'dart:convert';
import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/data/models/incidencia_model.dart';

class IncidenciaRepository {
  final ApiClient apiClient;

  IncidenciaRepository(this.apiClient);

  Future<List<Incidencia>> getAll({int size = 100}) async {
    try {
      final response = await apiClient.get('/api/incidencias?size=$size');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map<String, dynamic>) {
          list = (decoded['content'] ?? decoded['data'] ?? []) as List<dynamic>;
        } else {
          list = [];
        }
        return list.map((j) => Incidencia.fromJson(j)).toList();
      } else {
        throw Exception('Error al obtener incidencias: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: \$e');
    }
  }

  Future<List<Incidencia>> getByMaquina(int maquinaId) async {
    final all = await getAll();
    return all.where((i) => i.maquinaId == maquinaId).toList();
  }

  Future<void> createIncidencia({
    required String titulo,
    required String descripcion,
    required String estadoIncidencia,
    required int maquinaId,
    required int trabajadorId,
    required String prioridad,
    double? latitud,
    double? longitud,
  }) async {
    final body = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'estadoIncidencia': estadoIncidencia,
      'maquinaId': maquinaId,
      'trabajadorId': trabajadorId,
      'prioridad': prioridad,
    };
    if (latitud != null) body['latitud'] = latitud;
    if (longitud != null) body['longitud'] = longitud;

    final response = await apiClient.post(
      '/api/incidencias',
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear incidencia: \${response.statusCode}');
    }
  }
}
