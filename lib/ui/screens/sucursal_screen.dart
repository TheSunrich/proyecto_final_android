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
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  List<Sucursal> _sucursales = [];

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    final data = await DatabaseHelper().obtenerSucursales();
    setState(() {
      _sucursales = data;
    });
  }

  Future<void> _guardarSucursal() async {
    if (_nombreController.text.isEmpty) return;
    final sucursal = Sucursal(nombre: _nombreController.text, ubicacion: _ubicacionController.text);
    await DatabaseHelper().insertarSucursal(sucursal);
    _nombreController.clear();
    _ubicacionController.clear();
    _cargarSucursales();
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
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Busqueda',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Buscar sucursal',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.search_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            //ElevatedButton(onPressed: _guardarSucursal, child: const Text('Guardar')),
            const SizedBox(height: 24),
            SucursalList(sucursales: _sucursales),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/sucursal/save');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
