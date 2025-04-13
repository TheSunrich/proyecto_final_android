import 'package:flutter/material.dart';

import 'package:proyecto_final/data/models/sucursal.dart';

class SucursalListItem extends StatefulWidget {
  final Sucursal sucursal;

  const SucursalListItem({super.key, required this.sucursal});

  @override
  State<SucursalListItem> createState() => _SucursalListItemState();
}

class _SucursalListItemState extends State<SucursalListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.sucursal.nombre!),
        subtitle: Text(widget.sucursal.ubicacion!),
        trailing: IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () {
            // Aquí puedes agregar la lógica para eliminar la sucursal
          },
        ),
      ),
    );
  }
}
