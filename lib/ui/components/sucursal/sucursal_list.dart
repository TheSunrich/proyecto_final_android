import 'package:flutter/material.dart';
import 'package:proyecto_final/ui/components/sucursal/sucursal_list_item.dart';

class SucursalList extends StatelessWidget {
  final List sucursales;

  const SucursalList({super.key, required this.sucursales});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: sucursales.length,
        itemBuilder: (context, index) {
          final suc = sucursales[index];
          return SucursalListItem(sucursal: suc);
        },
      ),
    );
  }
}
