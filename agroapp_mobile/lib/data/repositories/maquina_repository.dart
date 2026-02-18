import 'dart:convert';

import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/data/models/maquina_model.dart';

class MaquinaRepository {
  final ApiClient apiClient;

  MaquinaRepository({required this.apiClient});

  Future <List<Maquina>> getMaquinas() async {
    try {
      final response = await apiClient.get('/api/maquinas');
      if (response.statusCode >= 200) {
        final List<dynamic> maquinaListJson = jsonDecode(response.body);
        return maquinaListJson.map((json) => Maquina.fromJson(json)).toList();
        
      }else{
        throw Exception('Error al obtener máquinas: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('Error al obtener máquinas: $e');
    }
  }

  Future <Maquina>getMaquinaById (int id) async {
    try {
      final response = await apiClient.get('/api/maquinas/$id');
      if (response.statusCode >= 200) {
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