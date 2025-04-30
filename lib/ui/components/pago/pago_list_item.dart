import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/venta.dart';

class PagoListItem extends StatefulWidget {
  final Venta venta;
  final Function reload;

  const PagoListItem({super.key, required this.venta, required this.reload});

  @override
  State<PagoListItem> createState() => _PagoListItemState();
}

class _PagoListItemState extends State<PagoListItem> {
  Venta get venta => widget.venta;
  Usuario? cliente;
  Usuario? vendedor;
  final dateFormat = DateFormat('dd MMM, yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _getCliente();
    _getVendedor();
  }

  _getCliente() async {
    final data = await DatabaseHelper().obtenerUsuarioPorId(
      venta.idCliente!,
    );
    setState(() {
      cliente = data;
    });
  }

  _getVendedor() async {
    final data = await DatabaseHelper().obtenerUsuarioPorId(
      venta.idVendedor!,
    );
    setState(() {
      vendedor = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          await Navigator.pushNamed(
                context,
                '/pago/save',
                arguments: venta,
              );
          widget.reload();
        },
        child: ListTile(
          title: Text(
            venta.isPayed ? 'Pago realizado' : 'Pago pendiente',
            style: TextStyle(
              color:
                  venta.isPayed
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cliente: ${cliente?.nombre ?? ''}'),
              Text('Vendedor: ${vendedor?.nombre ?? ''}'),
              Text('Fecha: ${dateFormat.format(venta.createdAt!)}'),
              Row(
                children: [
                  Text('Total: '),
                  Text(
                    '\$${venta.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
