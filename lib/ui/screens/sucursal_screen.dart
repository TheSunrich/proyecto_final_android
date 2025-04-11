import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';

import 'package:proyecto_final/ui/components/bottom_nav_bar.dart';

class SucursalScreen extends StatefulWidget {

  const SucursalScreen({super.key});

  @override
  State<SucursalScreen> createState() => _SucursalScreenState();
}

class _SucursalScreenState extends State<SucursalScreen> {
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
    final sucursal = Sucursal(
      nombre: _nombreController.text,
      ubicacion: _ubicacionController.text,
    );
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
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _ubicacionController,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _guardarSucursal,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _sucursales.length,
                itemBuilder: (context, index) {
                  final suc = _sucursales[index];
                  return ListTile(
                    title: Text(suc.nombre ?? 'Sin nombre'),
                    subtitle: Text(suc.ubicacion ?? 'Sin ubicación'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
