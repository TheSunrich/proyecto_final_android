import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_final/data/providers/nav_bar_provider.dart';

class BottomNavBarItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final String route;

  const BottomNavBarItem({
    super.key,
    required this.index,
    required this.label,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.watch<NavBarProvider>().selectedIndex;
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (selectedIndex == index || currentRoute == route) {
            return;
          }
          context.read<NavBarProvider>().setSelectedIndex(index);
          Navigator.pushReplacementNamed(context, route);
        },
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                selectedIndex == index
                    ? Colors.indigo.withValues(alpha: 0.1)
                    : Colors.transparent,
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selectedIndex == index ? Colors.indigo : Colors.grey,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selectedIndex == index ? Colors.indigo : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
