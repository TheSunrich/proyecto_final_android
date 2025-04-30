import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';

class MenuPrincipalScreen extends StatefulWidget {
  const MenuPrincipalScreen({super.key});

  @override
  State<MenuPrincipalScreen> createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  late final Usuario _loggedUser = context.read<LoginProvider>().usuario!;

  IconData _obtenerIconoRol() {
    switch (_loggedUser.rol) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'vendedor':
        return Icons.store;
      case 'cliente':
        return Icons.person;
      default:
        return Icons.account_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.read<LoginProvider>().obtenerColorRol();

    return Scaffold(
      appBar: CustomTheme.appBar(context, 'Bienvenido ${_loggedUser.nombre}'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_obtenerIconoRol(), size: 100, color: color),
              const SizedBox(height: 24),
              Text(
                'Bienvenido a la aplicación de ventas para ${_loggedUser.rol == 'admin'
                    ? 'Administrador'
                    : _loggedUser.rol == 'vendedor'
                    ? 'Vendedor'
                    : 'Cliente'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Esperamos que tengas una excelente experiencia!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
