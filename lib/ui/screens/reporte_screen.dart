import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  List<Map<String, dynamic>> _ventas = [];
  List<Map<String, dynamic>> _inventario = [];
  List<Sucursal> _sucursales = [];
  int? _sucursalSeleccionadaId;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    final ventas = await DatabaseHelper().obtenerVentasConDetalles();
    final sucursales = await DatabaseHelper().obtenerSucursales();

    setState(() {
      _ventas = ventas;
      _sucursales = sucursales;
      _sucursalSeleccionadaId = sucursales.isNotEmpty ? sucursales.first.id : null;
    });

    if (_sucursalSeleccionadaId != null) {
      _cargarInventario(_sucursalSeleccionadaId!);
    }
  }

  Future<void> _cargarInventario(int sucursalId) async {
    final data = await DatabaseHelper().obtenerInventarioPorSucursal(sucursalId);
    setState(() {
      _inventario = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Ventas Registradas', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _ventas.length,
                itemBuilder: (context, index) {
                  final venta = _ventas[index];
                  return ListTile(
                    title: Text('${venta['fecha']} – \$${venta['total']}'),
                    subtitle: Text(
                      'Sucursal: ${venta['sucursal'] ?? 'N/A'}\nCliente: ${venta['cliente'] ?? 'Sin cliente'} – Pago: ${venta['metodo_pago']}',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Inventario por Sucursal', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              value: _sucursalSeleccionadaId,
              isExpanded: true,
              items: _sucursales.map((s) {
                return DropdownMenuItem<int>(
                  value: s.id,
                  child: Text(s.nombre!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _sucursalSeleccionadaId = val;
                  _cargarInventario(val!);
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _inventario.length,
                itemBuilder: (context, index) {
                  final item = _inventario[index];
                  final bajoStock = item['stock'] <= 5;
                  return ListTile(
                    title: Text(item['nombre']),
                    subtitle: Text('Stock: ${item['stock']} – \$${item['precio']}'),
                    trailing: bajoStock
                        ? const Icon(Icons.warning, color: Colors.red)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
