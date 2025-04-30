import 'package:flutter/material.dart';
import 'package:proyecto_final/ui/components/producto/producto_list_item.dart';

class ProductoList extends StatelessWidget {
  final List productos;
  final Function reload;
  final Function(int, bool) delete;

  const ProductoList({super.key, required this.productos, required this.reload, required this.delete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final p = productos[index];
        return ProductoListItem(
          producto: p,
          reload: reload,
          delete: delete,
        );
      },
    );
  }
}
