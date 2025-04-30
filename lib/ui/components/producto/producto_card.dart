import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final int cantidad;
  final Function(int, int, double) actualizarCantidad;

  const ProductoCard({
    super.key,
    required this.producto,
    this.cantidad = 0,
    required this.actualizarCantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              producto.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$${producto.precio}'),
            Text('Stock: ${producto.stock}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (cantidad > 0) {
                      actualizarCantidad(
                        producto.id!,
                        cantidad - 1,
                        producto.precio,
                      );
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('$cantidad'),
                IconButton(
                  onPressed: () {
                    if (cantidad < producto.stock) {
                      actualizarCantidad(
                        producto.id!,
                        cantidad + 1,
                        producto.precio,
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
