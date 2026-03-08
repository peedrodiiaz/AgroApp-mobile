class Incidencia {
  final int id;
  final String titulo;
  final String? descripcion;
  final String estadoIncidencia;
  final String prioridad;
  final String? fechaApertura;
  final int? maquinaId;
  final String? maquinaNombre;
  final double? latitud;
  final double? longitud;

  Incidencia({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.estadoIncidencia,
    required this.prioridad,
    this.fechaApertura,
    this.maquinaId,
    this.maquinaNombre,
    this.latitud,
    this.longitud,
  });

  static String? _parseFecha(dynamic raw) {
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

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    final maquinaMap = json['maquina'] as Map<String, dynamic>?;
    return Incidencia(
      id: (json['id'] as num?)?.toInt() ?? 0,
      titulo: json['titulo'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      estadoIncidencia: json['estadoIncidencia'] as String? ?? '',
      prioridad: json['prioridad'] as String? ?? '',
      fechaApertura: _parseFecha(json['fechaApertura']),
      maquinaId: (maquinaMap?['id'] as num?)?.toInt(),
      maquinaNombre: maquinaMap?['nombre'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
    );
  }
}
