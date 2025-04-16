class Venta {
  final int? id;
  final String fecha;
  final int idSucursal;
  final int? idCliente;
  final String metodoPago;
  final double total;
  final DateTime? createdAt;

  Venta({
    this.id,
    required this.fecha,
    required this.idSucursal,
    this.idCliente,
    required this.metodoPago,
    required this.total,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'metodo_pago': metodoPago,
      'total': total,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Venta.fromJson(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      fecha: map['fecha'],
      idSucursal: map['id_sucursal'],
      idCliente: map['id_cliente'],
      metodoPago: map['metodo_pago'],
      total: map['total'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}