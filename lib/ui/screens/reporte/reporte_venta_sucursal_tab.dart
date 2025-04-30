import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/ui/components/reporte/reporte_venta_sucursal_item.dart';

class ReporteVentaSucursalTab extends StatefulWidget {
  const ReporteVentaSucursalTab({super.key});

  @override
  State<ReporteVentaSucursalTab> createState() =>
      _ReporteVentaSucursalTabState();
}

class _ReporteVentaSucursalTabState extends State<ReporteVentaSucursalTab> {
  List<Sucursal> _sucursales = [];
  int? _sucursalSeleccionadaId;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  List<Map<String, dynamic>> _ventas = [];
  Map<String, double> _ventasPorFecha = {};

  @override
  void initState() {
    super.initState();
    _fechaInicio = DateTime.now().subtract(const Duration(days: 5));
    _fechaFin = DateTime.now();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    final sucursales = await DatabaseHelper().obtenerSucursales();
    setState(() {
      _sucursales = sucursales;
      _sucursalSeleccionadaId =
          sucursales.isNotEmpty ? sucursales.first.id : null;
    });
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    if (_sucursalSeleccionadaId == null) return;
    final inicioStr = DateFormat('yyyy-MM-dd').format(_fechaInicio!);
    final finStr = DateFormat(
      'yyyy-MM-dd',
    ).format(_fechaFin!.add(const Duration(days: 1)));

    final result = await DatabaseHelper().obtenerTotalesVentasPorSucursal(
      _sucursalSeleccionadaId!,
      inicioStr,
      finStr,
    );

    final ventasPorFecha = <String, double>{};
    DateTime diaActual = _fechaInicio!;

    while (!diaActual.isAfter(_fechaFin!)) {
      final fechaStr = DateFormat('yyyy-MM-dd').format(diaActual);
      ventasPorFecha[fechaStr] = 0.0;
      diaActual = diaActual.add(const Duration(days: 1));
    }

    for (var row in result) {
      final fecha = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(row['created_at'] as String));
      ventasPorFecha.update(
        fecha,
        (value) => value + (row['total'] as num).toDouble(),
      );
    }

    setState(() {
      _ventas = result;
      _ventasPorFecha = ventasPorFecha;
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
      _cargarVentas();
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
      _cargarVentas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechas = _ventasPorFecha.keys.toList();
    final valores = _ventasPorFecha.values.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const SizedBox(height: 6),
          DropdownMenu<Sucursal>(
            width: double.infinity,
            initialSelection: _sucursales.isNotEmpty ? _sucursales.first : null,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isDense: true,
              constraints: BoxConstraints(maxHeight: 45),
            ),
            label: const Text('Sucursal'),
            hintText: 'Seleccione una sucursal',
            dropdownMenuEntries:
                _sucursales
                    .map((s) => DropdownMenuEntry(value: s, label: s.nombre))
                    .toList(),
            onSelected: (val) {
              setState(() => _sucursalSeleccionadaId = val?.id);
              _cargarVentas();
            },
          ),
          SizedBox(height: 12),
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
          if (fechas.isEmpty)
            const Center(child: Text('No hay ventas en este rango.')),
          if (fechas.isNotEmpty)
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < fechas.length) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                fechas[index].substring(5), // Solo MM-DD
                                style: const TextStyle(fontSize: 10),
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
                        reservedSize: 30,
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
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(fechas.length, (i) {
                        return FlSpot(i.toDouble(), double.parse(valores[i].toStringAsFixed(2)));
                      }),
                      isCurved: false,
                      color: Colors.indigo,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.indigo.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 32),
          ..._ventas.map((venta) {
            return ReporteVentaSucursalList(venta: venta);
          }),
        ],
      ),
    );
  }
}
