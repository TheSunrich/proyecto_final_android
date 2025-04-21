import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/ui/components/detalle_venta/detalle_venta_list.dart';

class PagoSaveScreen extends StatefulWidget {
  final Venta venta;

  const PagoSaveScreen({super.key, required this.venta});

  @override
  State<PagoSaveScreen> createState() => _PagoSaveScreenState();
}

class _PagoSaveScreenState extends State<PagoSaveScreen> {
  Venta get venta => widget.venta;
  final _metodoPagoController = TextEditingController();
  final List<String> _metodosPago = [
    'Efectivo',
    'Tarjeta de crédito',
    'Tarjeta de débito',
    'Transferencia bancaria',
    'PayPal',
  ];

  List<DetalleVenta> _detalleVenta = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _metodoPagoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });
    final detalleVenta = await DatabaseHelper().obtenerDetallesVenta(
      venta.id!,
    );
    setState(() {
      _detalleVenta = detalleVenta;
    });
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _guardarPago() async {
    if (_metodoPagoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione un método de pago'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final metodoPago = _metodoPagoController.text;

    await DatabaseHelper().pagarVenta(
      venta.id!,
      metodoPago,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pago guardado con éxito'),
        duration: Duration(seconds: 2),
      ),
    );
    _metodoPagoController.clear();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la venta'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownMenu(
              controller: _metodoPagoController,
              width: double.infinity,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              label: const Text('Método de pago'),
              hintText: 'Seleccione un método de pago',
              dropdownMenuEntries:
                  _metodosPago
                      .map(
                        (s) => DropdownMenuEntry(value: s, label: s.toString()),
                      )
                      .toList(),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _guardarPago(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Pagar Venta'),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lista de productos de la venta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total: '),
                    Text(
                      '\$${venta.total}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _detalleVenta.isEmpty
                ? const Expanded(
                  child: Center(child: Text('No se encontraron productos.')),
                )
                : Expanded(
                  child: DetalleVentaList(detalleVenta: _detalleVenta),
                ),
          ],
        ),
      ),
    );
  }
}
