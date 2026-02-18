class Trabajador {
  final int id;
  final String nombre;
  final String apellido;
  final String dni;
  final String email;
  final String telefono;
  final String rol;

  Trabajador({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  //Convierte JSON a objeto Trabajador
  factory Trabajador.fromJson(Map<String, dynamic> json) {
    return Trabajador(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      dni: json['dni'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      rol: json['rol'] ?? 'USER',
    );
  }

  // Nombre completo
  String get nombreCompleto => '$nombre $apellido';
}
