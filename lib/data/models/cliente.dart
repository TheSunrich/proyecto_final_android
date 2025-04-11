class Cliente {
  final int? id;
  final String nombre;
  final String telefono;
  final String email;

  Cliente({
    this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
    };
  }
}
