import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';

class ClienteListItem extends StatelessWidget {
  final Usuario cliente;
  final Function reload;
  final Function(int, bool) delete;

  const ClienteListItem({
    super.key,
    required this.cliente,
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
                '/cliente/save',
                arguments: cliente,
              )
              as Usuario?;
          reload();
        },
        onLongPress: loggedUser.rol == 'admin' ? () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    cliente.isActive ? 'Eliminar cliente' : 'Restaurar cliente',
                  ),
                  content: Text(
                    '¿Estás seguro de que deseas ${cliente.isActive ? 'eliminar' : 'restaurar'} este cliente?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        delete(cliente.id!, cliente.isActive);
                        Navigator.pop(context);
                        reload();
                      },
                      child: Text(cliente.isActive ? 'Eliminar' : 'Restaurar'),
                    ),
                  ],
                ),
          );
        } : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade400,
                child: Text(
                  cliente.nombre[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(cliente.nombre), Text(cliente.email!)],
                ),
              ),
              loggedUser.rol == 'admin'
                  ? Container(
                    alignment: Alignment.topRight,
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cliente.isActive ? Colors.green : Colors.red,
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
