import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/ui/components/pago/pago_list_item.dart';

class PagoList extends StatelessWidget {
  final List<Venta> ventas;
  final Function reload;

  const PagoList({super.key, required this.ventas, required this.reload});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ventas.length,
      itemBuilder: (context, index) {
        final v = ventas[index];
        return PagoListItem(
          venta: v,
          reload: reload,
        );
      },
    );
  }
}
