

class Sucursal {
  int? id;
  String nombre;
  String ubicacion;
  bool isActive;

  Sucursal({
    this.id,
    required this.nombre,
    required this.ubicacion,
    this.isActive = true,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      ubicacion: json['ubicacion'] as String,
      isActive: json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'is_active': isActive ? 1 : 0,
    };
  }
}


