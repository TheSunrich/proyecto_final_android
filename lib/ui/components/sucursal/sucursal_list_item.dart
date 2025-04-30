import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';

class SucursalListItem extends StatelessWidget {
  final Sucursal sucursal;
  final Function reload;
  final Function(int, bool) delete;

  const SucursalListItem({
    super.key,
    required this.sucursal,
    required this.reload,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    final loggedUser = context.read<LoginProvider>().usuario!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          await Navigator.pushNamed(
                context,
                '/sucursal/save',
                arguments: sucursal,
              )
              as Sucursal?;
          reload();
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(sucursal.isActive ? 'Eliminar sucursal' : 'Restaurar sucursal'),
                  content: Text(
                    '¿Estás seguro de ${sucursal.isActive ? 'Eliminar' : 'restaurar'} esta sucursal?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        delete(sucursal.id!, sucursal.isActive);
                        Navigator.pop(context, true);
                        reload();
                      },
                      child: Text(sucursal.isActive ? 'Eliminar' : 'Restaurar'),
                    ),
                  ],
                ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sucursal.nombre),
                    Text(sucursal.ubicacion),
                  ],
                ),
              ),
              loggedUser.rol == 'admin'
                  ? Container(
                alignment: Alignment.topRight,
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: sucursal.isActive ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
