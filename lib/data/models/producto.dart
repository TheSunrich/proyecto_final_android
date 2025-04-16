class Producto {
  final int? id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final int idSucursal;
  final bool isActive;

  Producto({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    required this.idSucursal,
    this.isActive = true,
  });

  factory Producto.fromJson(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'],
      stock: map['stock'],
      idSucursal: map['id_sucursal'],
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'id_sucursal': idSucursal,
      'is_active': isActive ? 1 : 0,
    };
  }
}