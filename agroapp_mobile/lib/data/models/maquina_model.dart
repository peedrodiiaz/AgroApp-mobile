class Maquina {
  final int id;
  final String nombre;
  final String? modelo;
  final String? numSerie;
  final String? fechaCompra;
  final String estado;
  final String? imagen;

  Maquina({
    required this.id,
    required this.nombre,
    this.modelo,
    this.numSerie,
    this.fechaCompra,
    required this.estado,
    this.imagen,
  });

  factory Maquina.fromJson(Map<String, dynamic> json) {
    String? fechaCompraStr;
    final raw = json['fechaCompra'];
    if (raw is String) {
      fechaCompraStr = raw;
    } else if (raw is List && raw.length >= 3) {
      final y = raw[0].toString().padLeft(4, '0');
      final m = raw[1].toString().padLeft(2, '0');
      final d = raw[2].toString().padLeft(2, '0');
      fechaCompraStr = '$y-$m-$d';
    }

    return Maquina(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      modelo: json['modelo'] as String?,
      numSerie: json['numSerie'] as String?,
      fechaCompra: fechaCompraStr,
      estado: (json['estado'] as String?) ?? '',
      imagen: json['imagen'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'modelo': modelo,
      'numSerie': numSerie,
      'fechaCompra': fechaCompra,
      'estado': estado,
      'imagen': imagen,
    };
  }
}
