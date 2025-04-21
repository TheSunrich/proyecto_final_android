import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/ui/components/detalle_venta/detalle_venta_list_item.dart';

class DetalleVentaList extends StatelessWidget {
  final List<DetalleVenta> detalleVenta;

  const DetalleVentaList({super.key, required this.detalleVenta});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detalleVenta.length,
      itemBuilder: (context, index) {
        final p = detalleVenta[index];
        return DetalleVentaListItem(
          detalleVenta: p,
        );
      },
    );
  }
}
