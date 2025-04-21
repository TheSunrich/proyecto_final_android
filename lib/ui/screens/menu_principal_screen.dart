import 'package:flutter/material.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';
import 'package:proyecto_final/ui/screens/cliente/cliente_screen.dart';
import 'package:proyecto_final/ui/screens/producto/producto_screen.dart';
import 'package:proyecto_final/ui/screens/reporte_screen.dart';
import 'package:proyecto_final/ui/screens/sucursal/sucursal_screen.dart';
import 'package:proyecto_final/ui/screens/venta/venta_screen.dart';

class MenuPrincipalScreen extends StatelessWidget {
  final Usuario usuario;

  const MenuPrincipalScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${usuario.nombre}'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
      body: ListView(
        children: [
          if (usuario.rol == 'admin') ...[
            ListTile(
              title: const Text('Sucursales'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SucursalScreen()),
                  ),
            ),
            ListTile(
              title: const Text('Productos'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductoScreen()),
                  ),
            ),
          ],
          ListTile(
            title: const Text('Clientes'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClienteScreen()),
                ),
          ),
          ListTile(
            title: const Text('Ventas'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VentaScreen()),
                ),
          ),
          ListTile(
            title: const Text('Reportes'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportesScreen()),
                ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
