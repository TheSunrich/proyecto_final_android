import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';

class ProductoListItem extends StatelessWidget {
  final Producto producto;
  final Function reload;
  final Function(int, bool) delete;

  const ProductoListItem({
    super.key,
    required this.producto,
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
                '/producto/save',
                arguments: {
                  'producto': producto,
                  'idSucursal': producto.idSucursal,
                },
              )
              as Producto?;
          reload();
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(producto.isActive ? 'Eliminar Producto' : 'Reactivar Producto'),
                content: Text(
                  '¿Estás seguro de que deseas ${producto.isActive ? 'eliminar' : 'reactivar'} este producto?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      delete(producto.id!, producto.isActive);
                      Navigator.of(context).pop();
                      reload();
                    },
                    child: Text(
                      producto.isActive ? 'Eliminar' : 'Reactivar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Existencias: ${producto.stock}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  'Precio: \$${producto.precio}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              loggedUser.rol == 'admin'
                  ? Container(
                    alignment: Alignment.topRight,
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: producto.isActive ? Colors.green : Colors.red,
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
