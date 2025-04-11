class Usuario {
  final int? id;
  final String nombre;
  final String contrasena;
  final String rol;

  Usuario({
    this.id,
    required this.nombre,
    required this.contrasena,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      contrasena: map['contrasena'],
      rol: map['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'contrasena': contrasena,
      'rol': rol,
    };
  }
}
