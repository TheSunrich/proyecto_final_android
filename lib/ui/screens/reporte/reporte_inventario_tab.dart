import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';

class ReporteInventarioTab extends StatefulWidget {
  const ReporteInventarioTab({super.key});

  @override
  State<ReporteInventarioTab> createState() => _ReporteInventarioTabState();
}

class _ReporteInventarioTabState extends State<ReporteInventarioTab> {
  List<Sucursal> _sucursales = [];
  int? _sucursalSeleccionadaId;
  Map<String, int> _inventario = {};

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    final sucursales = await DatabaseHelper().obtenerSucursales();
    setState(() {
      _sucursales = sucursales;
      _sucursalSeleccionadaId = sucursales.isNotEmpty ? sucursales.first.id : null;
    });

    if (_sucursalSeleccionadaId != null) {
      _cargarInventario(_sucursalSeleccionadaId!);
    }
  }

  Future<void> _cargarInventario(int sucursalId) async {
    final data = await DatabaseHelper().obtenerInventarioPorSucursal(sucursalId);
    final inventario = <String, int>{};

    for (final item in data) {
      inventario[item['nombre']] = item['stock'];
    }

    setState(() {
      _inventario = inventario;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalProductos = _inventario.length;
    final totalStock = _inventario.values.fold(0, (sum, e) => sum + e);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownMenu<Sucursal>(
            initialSelection: _sucursalSeleccionadaId != null
                ? _sucursales.firstWhere((s) => s.id == _sucursalSeleccionadaId)
                : null,
            width: double.infinity,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            label: const Text('Sucursal'),
            hintText: 'Seleccione una sucursal',
            onSelected: (Sucursal? val) {
              setState(() {
                _sucursalSeleccionadaId = val?.id;
                if (_sucursalSeleccionadaId != null) {
                  _cargarInventario(_sucursalSeleccionadaId!);
                }
              });
            },
            dropdownMenuEntries: _sucursales.map((s) {
              return DropdownMenuEntry<Sucursal>(
                value: s,
                label: s.nombre,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          if (totalProductos == 0)
            const Text('No hay productos en esta sucursal.')
          else ...[
            const Text('Inventario por producto:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: _inventario.entries.map((entry) {
                    final porcentaje = (entry.value / totalStock) * 100;
                    final color = (porcentaje / 10).round() * 100;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}',
                      color: color < 100 ? Colors.indigo[50] : color > 900 ? Colors.indigo : Colors.indigo[color.toInt()],
                      radius: MediaQuery.of(context).size.width * 0.3,
                      titleStyle: const TextStyle(fontSize: 11, color: Colors.white),
                      showTitle: true,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
