import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/producto.dart';

class ProductoListItem extends StatelessWidget {
  final Producto producto;
  final Function reload;
  final Function(int) delete;

  const ProductoListItem({
    super.key,
    required this.producto,
    required this.reload,
    required this.delete,
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
                title: const Text('Eliminar Producto'),
                content: const Text(
                  '¿Estás seguro de que deseas eliminar este producto?',
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
                      delete(producto.id!);
                      Navigator.of(context).pop();
                      reload();
                    },
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: ListTile(
          title: Text(producto.nombre),
          subtitle: Text(producto.descripcion!),
        ),
      ),
    );
  }
}
