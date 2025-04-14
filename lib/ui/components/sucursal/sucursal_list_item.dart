import 'package:flutter/material.dart';

import 'package:proyecto_final/data/models/sucursal.dart';

class SucursalListItem extends StatelessWidget {
  final Sucursal sucursal;
  final Function reload;

  const SucursalListItem({
    super.key,
    required this.sucursal,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(sucursal.nombre),
        subtitle: Text(sucursal.ubicacion),
        trailing: IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () {
            Navigator.pushNamed(context, '/sucursal/save', arguments: sucursal)
                as Sucursal?;
            reload();
          },
        ),
      ),
    );
  }
}
