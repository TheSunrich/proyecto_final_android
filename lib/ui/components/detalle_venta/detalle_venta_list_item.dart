import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/data/models/producto.dart';

class DetalleVentaListItem extends StatefulWidget {
  final DetalleVenta detalleVenta;

  const DetalleVentaListItem({super.key, required this.detalleVenta});

  @override
  State<DetalleVentaListItem> createState() => _DetalleVentaListItemState();
}

class _DetalleVentaListItemState extends State<DetalleVentaListItem> {
  DetalleVenta get detalleVenta => widget.detalleVenta;
  Producto? _producto;

  @override
  void initState() {
    super.initState();
    _getProducto();
  }

  _getProducto() async {
    final producto = await DatabaseHelper().obtenerProductoPorId(
        detalleVenta.idProducto
    );
    setState(() {
      _producto = producto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          _producto?.nombre ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cantidad: ${detalleVenta.cantidad}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Precio Unitario: ${detalleVenta.precioUnitario.toStringAsFixed(2)}'),
                Text('Subtotal: \$${(detalleVenta.precioUnitario * detalleVenta.cantidad).toStringAsFixed(2)}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
