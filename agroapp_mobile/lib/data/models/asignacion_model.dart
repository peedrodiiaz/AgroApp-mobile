import 'package:agroapp_mobile/data/models/trabajador_response.dart';

import 'maquina_model.dart';


class Asignacion {
  final int id;
  final Maquina maquina;
  final Trabajador trabajador;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? descripcion;

  Asignacion({
    required this.id,
    required this.maquina,
    required this.trabajador,
    required this.fechaInicio,
    this.fechaFin,
    this.descripcion,
  });

  // Convierte JSON  a objeto Asignacion
  factory Asignacion.fromJson(Map<String, dynamic> json) {
    return Asignacion(
      id: json['id'] ?? 0,
      maquina: Maquina.fromJson(json['maquina'] ?? {}),
      trabajador: Trabajador.fromJson(json['trabajador'] ?? {}),
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: json['fechaFin'] != null 
          ? DateTime.parse(json['fechaFin']) 
          : null,
      descripcion: json['descripcion'],
    );
  }

  /// Verifica si la asignación está activa
  bool get isActiva => fechaFin == null || fechaFin!.isAfter(DateTime.now());
}
