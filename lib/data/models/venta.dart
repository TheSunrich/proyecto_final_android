class Venta {
  final int? id;
  final int idSucursal;
  final int? idCliente;
  final int? idVendedor;
  final String? metodoPago;
  final double total;
  final DateTime? createdAt;
  final bool isPayed;

  Venta({
    this.id,
    required this.idSucursal,
    this.idCliente,
    this.idVendedor,
    this.metodoPago,
    required this.total,
    DateTime? createdAt,
    this.isPayed = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'id_vendedor': idVendedor,
      'metodo_pago': metodoPago,
      'total': total,
      'created_at': createdAt?.toIso8601String(),
      'is_payed': isPayed ? 1 : 0,
    };
  }

  factory Venta.fromJson(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      idSucursal: map['id_sucursal'],
      idCliente: map['id_cliente'],
      idVendedor: map['id_vendedor'],
      metodoPago: map['metodo_pago'],
      total: map['total'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      isPayed: map['is_payed'] == 1,
    );
  }
}