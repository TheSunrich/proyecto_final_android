class Venta {
  final int? id;
  final String fecha;
  final int idSucursal;
  final int? idCliente;
  final String metodoPago;
  final double total;

  Venta({
    this.id,
    required this.fecha,
    required this.idSucursal,
    required this.idCliente,
    required this.metodoPago,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'metodo_pago': metodoPago,
      'total': total,
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
    );
  }
}