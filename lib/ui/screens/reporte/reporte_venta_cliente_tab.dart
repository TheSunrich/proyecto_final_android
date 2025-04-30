import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/ui/components/reporte/reporte_venta_cliente_item.dart';

class ReporteVentaClienteTab extends StatefulWidget {
  const ReporteVentaClienteTab({super.key});

  @override
  State<ReporteVentaClienteTab> createState() => _ReporteVentaClienteTabState();
}

class _ReporteVentaClienteTabState extends State<ReporteVentaClienteTab> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  Map<String, double> _gastosPorCliente = {};
  List<Map<String, dynamic>> _clientes = [];

  @override
  void initState() {
    super.initState();
    _fechaInicio = DateTime.now().subtract(const Duration(days: 5));
    _fechaFin = DateTime.now();
    _cargarGastosClientes();
  }

  Future<void> _cargarGastosClientes() async {
    final inicioStr = DateFormat('yyyy-MM-dd').format(_fechaInicio!);
    final finStr = DateFormat('yyyy-MM-dd').format(_fechaFin!);

    final result = await DatabaseHelper().obtenerTotalesVentasPorCliente(
      inicioStr,
      finStr,
    );

    final gastos = <String, double>{};
    final clientesList = <Map<String, dynamic>>[];

    for (final row in result) {
      gastos[row['cliente'] as String] = (row['gasto'] as num?)?.toDouble() ?? 0.0;
      clientesList.add({
        'cliente': row['cliente'],
        'gasto': (row['gasto'] as num?)?.toDouble() ?? 0.0,
        'email': row['email'],
      });
    }

    setState(() {
      _gastosPorCliente = gastos;
      _clientes = clientesList;
    });
  }

  Future<void> _seleccionarFechaInicio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio!,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _fechaInicio = picked);
      _cargarGastosClientes();
    }
  }

  Future<void> _seleccionarFechaFin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin!,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _fechaFin = picked);
      _cargarGastosClientes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientes = _gastosPorCliente.keys.toList();
    final gastos = _gastosPorCliente.values.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _seleccionarFechaInicio,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Desde: ${DateFormat('yyyy-MM-dd').format(_fechaInicio!)}',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _seleccionarFechaFin,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Hasta: ${DateFormat('yyyy-MM-dd').format(_fechaFin!)}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (clientes.isEmpty)
            const Center(child: Text('No hay ventas registradas en este rango.'))
          else
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i >= 0 && i < clientes.length) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                clientes[i],
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              '\$${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(clientes.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: double.parse(gastos[i].toStringAsFixed(2)),
                          width: 20,
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          const SizedBox(height: 32),
          const Text('Lista de Clientes:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._clientes.map((cliente) {
            return ReporteVentaClienteItem(cliente: cliente);
          }),
        ],
      ),
    );
  }
}
