import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';
import 'package:proyecto_final/data/providers/nav_bar_provider.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar_item.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int selectedIndex = context.watch<NavBarProvider>().selectedIndex;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> navBarItems = [
    {
      'key': GlobalKey(),
      'icon': Icons.home_rounded,
      'label': 'Inicio',
      'route': '/main',
      'role': [
        'admin',
        'vendedor',
        'cliente',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.corporate_fare_rounded,
      'label': 'Sucursales',
      'route': '/sucursal',
      'role': [
        'admin',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.inventory_2_rounded,
      'label': 'Productos',
      'route': '/producto',
      'role': [
        'admin',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.people_alt_rounded,
      'label': 'Clientes',
      'route': '/cliente',
      'role': [
        'admin',
        'vendedor',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.shopping_cart_rounded,
      'label': 'Venta',
      'route': '/venta',
      'role': [
        'admin',
        'vendedor',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.payment_rounded,
      'label': 'Pagos',
      'route': '/pago',
      'role': [
        'cliente',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.recent_actors_rounded,
      'label': 'Reportes',
      'route': '/reporte',
      'role': [
        'admin',
      ],
    },
    {
      'key': GlobalKey(),
      'icon': Icons.logout_rounded,
      'label': 'Cerrar Sesión',
      'route': '/login',
      'role': [
        'admin',
        'vendedor',
        'cliente',
      ],
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _goToIndex(selectedIndex);
  }

  void _goToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = navBarItems[index]['key'].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        );
        _scrollController.animateTo(
          _scrollController.offset + position.dx - 0.5 * MediaQuery.of(context).size.width + 45,
          // 100 es un padding para centrar
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.watch<LoginProvider>().usuario!.rol;

    return BottomAppBar(
      height: 85,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(navBarItems.length, (index) {
            final item = navBarItems[index];
            if (item['role'].contains(userRole)) {
              return BottomNavBarItem(
                index: index,
                key: navBarItems[index]['key'] as GlobalKey,
                label: navBarItems[index]['label'] as String,
                icon: navBarItems[index]['icon'] as IconData,
                route: navBarItems[index]['route'] as String,
              );
            }
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}