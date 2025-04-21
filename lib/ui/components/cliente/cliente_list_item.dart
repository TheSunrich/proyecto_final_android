import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/usuario.dart';

class ClienteListItem extends StatelessWidget {
  final Usuario cliente;
  final Function reload;

  const ClienteListItem({
    super.key,
    required this.cliente,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          await Navigator.pushNamed(
                context,
                '/cliente/save',
                arguments: cliente,
              )
              as Usuario?;
          reload();
        },
        child: ListTile(
          title: Text(cliente.nombre),
          subtitle: Text(cliente.email!),
        ),
      ),
    );
  }
}
