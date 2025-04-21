class Usuario {
  final int? id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String contrasena;
  final String rol;

  Usuario({
    this.id,
    required this.nombre,
    this.telefono,
    this.email,
    required this.contrasena,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      email: map['email'],
      contrasena: map['contrasena'],
      rol: map['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'contrasena': contrasena,
      'rol': rol,
    };
  }
}
