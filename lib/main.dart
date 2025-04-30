import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';
import 'package:proyecto_final/data/providers/nav_bar_provider.dart';
import 'package:proyecto_final/ui/screens/cliente/cliente_save_screen.dart';
import 'package:proyecto_final/ui/screens/cliente/cliente_screen.dart';
import 'package:proyecto_final/ui/screens/login_screen.dart';
import 'package:proyecto_final/ui/screens/menu_principal_screen.dart';
import 'package:proyecto_final/ui/screens/pago/pago_save_screen.dart';
import 'package:proyecto_final/ui/screens/pago/pago_screen.dart';
import 'package:proyecto_final/ui/screens/producto/producto_save_screen.dart';
import 'package:proyecto_final/ui/screens/producto/producto_screen.dart';
import 'package:proyecto_final/ui/screens/reporte/reporte_screen.dart';
import 'package:proyecto_final/ui/screens/sucursal/sucursal_save_screen.dart';
import 'package:proyecto_final/ui/screens/sucursal/sucursal_screen.dart';
import 'package:proyecto_final/ui/screens/venta/venta_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavBarProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
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
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/sucursal': (context) => SucursalScreen(),
        '/sucursal/save':
            (context) => SucursalSaveScreen(
              sucursal: ModalRoute.of(context)?.settings.arguments as Sucursal?,
            ),
        '/producto': (context) => ProductoScreen(),
        '/producto/save': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          return ProductoSaveScreen(
            producto: args['producto'] as Producto?,
            idSucursal: args['idSucursal'] as int,
          );
        },
        '/cliente': (context) => ClienteScreen(),
        '/cliente/save':
            (context) => ClienteSaveScreen(
              cliente: ModalRoute.of(context)?.settings.arguments as Usuario?,
            ),
        '/venta': (context) => VentaScreen(),
        '/pago': (context) => PagoScreen(),
        '/pago/save':
            (context) => PagoSaveScreen(
              venta: ModalRoute.of(context)?.settings.arguments as Venta,
            ),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MenuPrincipalScreen(),
        '/reporte': (context) => ReportesScreen(),
      },
    );
  }
}
