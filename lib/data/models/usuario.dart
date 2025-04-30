class Usuario {
  final int? id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String contrasena;
  final String rol;
  final bool isActive;

  Usuario({
    this.id,
    required this.nombre,
    this.telefono,
    this.email,
    required this.contrasena,
    required this.rol,
    this.isActive = true,
  });

  factory Usuario.fromJson(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      email: map['email'],
      contrasena: map['contrasena'],
      rol: map['rol'],
      isActive: map['is_active'] == 1,
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
      'is_active': isActive ? 1 : 0,
    };
  }
}
