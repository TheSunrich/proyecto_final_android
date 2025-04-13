import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/providers/nav_bar_provider.dart';
import 'package:proyecto_final/ui/screens/cliente_screen.dart';
import 'package:proyecto_final/ui/screens/login_screen.dart';
import 'package:proyecto_final/ui/screens/menu_principal_screen.dart';
import 'package:proyecto_final/ui/screens/producto_screen.dart';
import 'package:proyecto_final/ui/screens/reporte_screen.dart';
import 'package:proyecto_final/ui/screens/sucursal/sucursal_save_screen.dart';
import 'package:proyecto_final/ui/screens/sucursal_screen.dart';
import 'package:proyecto_final/ui/screens/venta_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => NavBarProvider(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Inventario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/main',
      routes: {
        '/sucursal': (context) => SucursalScreen(),
        '/sucursal/save': (context) => SucursalSaveScreen(),
        '/producto': (context) => ProductoScreen(),
        '/cliente': (context) => ClienteScreen(),
        '/venta': (context) => VentaScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MenuPrincipalScreen(usuario: Usuario(nombre: 'nombre', contrasena: '*****', rol: 'admin')),
        '/reporte': (context) => ReportesScreen(),

      },
    );
  }
}
