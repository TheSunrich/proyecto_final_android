import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/sucursal.dart';

import '../components/navbar/bottom_nav_bar.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  int? _sucursalSeleccionadaId;
  List<Sucursal> _sucursales = [];
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    final data = await DatabaseHelper().obtenerSucursales();
    setState(() {
      _sucursales = data;
      if (_sucursales.isNotEmpty) {
        _sucursalSeleccionadaId ??= _sucursales.first.id;
        _cargarProductos();
      }
    });
  }

  Future<void> _cargarProductos() async {
    if (_sucursalSeleccionadaId == null) return;
    final data = await DatabaseHelper().obtenerProductosPorSucursal(
      _sucursalSeleccionadaId!,
    );
    setState(() {
      _productos = data;
    });
  }

  Future<void> _guardarProducto() async {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _sucursalSeleccionadaId == null)
      return;

    final producto = Producto(
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      precio: double.tryParse(_precioController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      idSucursal: _sucursalSeleccionadaId!,
    );

    await DatabaseHelper().insertarProducto(producto);
    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
    _stockController.clear();
    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: _sucursalSeleccionadaId,
              hint: const Text('Selecciona una sucursal'),
              items:
                  _sucursales.map((s) {
                    return DropdownMenuItem<int>(
                      value: s.id,
                      child: Text(s.nombre!),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  _sucursalSeleccionadaId = val;
                  _cargarProductos();
                });
              },
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
              ),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _guardarProducto,
              child: const Text('Guardar Producto'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final p = _productos[index];
                  return ListTile(
                    title: Text(p.nombre),
                    subtitle: Text('Precio: \$${p.precio} - Stock: ${p.stock}'),
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
