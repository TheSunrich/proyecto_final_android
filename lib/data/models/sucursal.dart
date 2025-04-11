

class Sucursal {
  int? id;
  String? nombre;
  String? ubicacion;

  Sucursal({
    this.id,
    this.nombre,
    this.ubicacion
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      ubicacion: json['ubicacion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
    };
  }
}