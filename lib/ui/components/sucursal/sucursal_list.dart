import 'package:flutter/material.dart';
import 'package:proyecto_final/ui/components/sucursal/sucursal_list_item.dart';

class SucursalList extends StatelessWidget {
  final List sucursales;
  final Function reload;
  final Function(int, bool) delete;

  const SucursalList({
    super.key,
    required this.sucursales,
    required this.reload,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sucursales.length,
      itemBuilder: (context, index) {
        final suc = sucursales[index];
        return SucursalListItem(sucursal: suc, reload: reload, delete: delete);
      },
    );
  }
}
