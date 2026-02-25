import 'package:agroapp_mobile/core/network/api_client.dart';

class IncidenciaRepository {
  final ApiClient apiClient;

  IncidenciaRepository(this.apiClient);

  Future<void> createIncidencia({
    required String titulo,
    required String descripcion,
    required String estadoIncidencia,
    required int maquinaId,
    required int trabajadorId,
    required String prioridad,
  }) async {
    final response = await apiClient.post(
      '/api/incidencias',
      body: {
        'titulo': titulo,
        'descripcion': descripcion,
        'estadoIncidencia': estadoIncidencia,
        'maquinaId': maquinaId,
        'trabajadorId': trabajadorId,
        'prioridad': prioridad,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear incidencia: ${response.statusCode}');
    }
  }

}
