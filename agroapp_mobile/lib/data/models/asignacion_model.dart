import 'package:agroapp_mobile/data/models/trabajador_response.dart';

import 'maquina_model.dart';

class Asignacion {
  final int id;
  final Maquina maquina;
  final Trabajador trabajador;
  final String fechaInicio;
  final String? fechaFin;
  final String? descripcion;

  Asignacion({
    required this.id,
    required this.maquina,
    required this.trabajador,
    required this.fechaInicio,
    this.fechaFin,
    this.descripcion,
  });

  static String? _parseLocalDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is List && raw.length >= 3) {
      final y = raw[0].toString().padLeft(4, '0');
      final m = raw[1].toString().padLeft(2, '0');
      final d = raw[2].toString().padLeft(2, '0');
      return '$y-$m-$d';
    }
    return null;
  }

  factory Asignacion.fromJson(Map<String, dynamic> json) {
    return Asignacion(
      id: (json['id'] as num?)?.toInt() ?? 0,
      maquina: Maquina.fromJson(json['maquina'] ?? {}),
      trabajador: Trabajador.fromJson(json['trabajador'] ?? {}),
      fechaInicio: _parseLocalDate(json['fechaInicio']) ?? '',
      fechaFin: _parseLocalDate(json['fechaFin']),
      descripcion: json['descripcion'] as String?,
    );
  }

  bool get isActiva {
    if (fechaFin == null) return true;
    final fin = DateTime.tryParse(fechaFin!);
    return fin == null || fin.isAfter(DateTime.now());
  }
}
