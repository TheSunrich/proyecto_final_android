import 'package:flutter/material.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';
import 'package:proyecto_final/ui/screens/reporte/reporte_inventario_tab.dart';
import 'package:proyecto_final/ui/screens/reporte/reporte_venta_cliente_tab.dart';
import 'package:proyecto_final/ui/screens/reporte/reporte_venta_sucursal_tab.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomTheme.appBar(
          context,
          'Reportes',
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                text: 'Ventas por Cliente',
                icon: Icon(Icons.bar_chart_rounded),
              ),
              Tab(
                text: 'Ventas por Sucursal',
                icon: Icon(Icons.timeline_rounded),
              ),
              Tab(text: 'Inventario', icon: Icon(Icons.inventory_2_rounded)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReporteVentaClienteTab(),
            ReporteVentaSucursalTab(),
            ReporteInventarioTab(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
