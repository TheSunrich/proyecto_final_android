import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';

import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';
import 'package:proyecto_final/ui/components/sucursal/sucursal_list.dart';

class SucursalScreen extends StatefulWidget {
  const SucursalScreen({super.key});

  @override
  State<SucursalScreen> createState() => _SucursalScreenState();
}

class _SucursalScreenState extends State<SucursalScreen> {
  final _searchController = TextEditingController();
  List<Sucursal> _sucursales = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    setState(() {
      _isLoading = true;
    });
    final data = await DatabaseHelper().obtenerSucursales(_searchController.text.trim());
    setState(() {
      _sucursales = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sucursales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Busqueda',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Buscar sucursal',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        radius: 10,
                        onTap: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                          _cargarSucursales();
                        },

                        child: Icon(Icons.clear_rounded),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed:
                      _isLoading || _sucursales.isEmpty
                          ? null
                          : _cargarSucursales,
                  icon: Icon(Icons.search_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _sucursales.isEmpty
                ? Expanded(
                  child: Center(child: Text('No hay sucursales registradas')),
                )
                : Expanded(
                  child: SucursalList(
                    sucursales: _sucursales,
                    reload: _cargarSucursales,
                  ),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.pushNamed(context, '/sucursal/save');
          if (res == true) {
            _cargarSucursales();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
