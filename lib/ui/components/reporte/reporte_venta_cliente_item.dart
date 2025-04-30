import 'package:flutter/material.dart';

class ReporteVentaClienteItem extends StatelessWidget {
  final Map<String, dynamic> cliente;

  const ReporteVentaClienteItem({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente['cliente'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(cliente['email'] ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${(cliente['gasto'] as double).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
