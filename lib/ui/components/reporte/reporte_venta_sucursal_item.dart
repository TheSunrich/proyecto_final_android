import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReporteVentaSucursalList extends StatelessWidget {
  final Map<String, dynamic> venta;

  const ReporteVentaSucursalList({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.parse(venta['created_at']));

    return Padding(
      padding: EdgeInsets.all(4),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${(venta['total'] as double).toStringAsFixed(2)} – ${venta['cliente']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('$fecha • ${venta['metodo_pago'] ?? ''}'),
            ],
          ),
        ),
      ),
    );
  }
}
