class Maquina {
  final int id;
  final String nombre;
  final String tipo;
  final String matricula;
  final String estado;
  final DateTime? fechaAdquisicion;

  Maquina({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.matricula,
    required this.estado,
    this.fechaAdquisicion,
  });

  // Convierte JSON a objeto máquina
  factory Maquina.fromJson(Map<String, dynamic> json) {
    return Maquina(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      matricula: json['matricula'] ?? '',
      estado: json['estado'] ?? '',
      fechaAdquisicion: json['fechaAdquisicion'] != null
          ? DateTime.parse(json['fechaAdquisicion'])
          : null,
    );
  }

  // Convierte objeto Maquina a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'matricula': matricula,
      'estado': estado,
      'fechaAdquisicion': fechaAdquisicion?.toIso8601String(),
    };
  }
}
