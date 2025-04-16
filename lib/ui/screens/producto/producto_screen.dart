import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/ui/components/producto/producto_list.dart';

import '../../components/navbar/bottom_nav_bar.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  int? _sucursalSeleccionadaId;
  List<Sucursal> _sucursales = [];
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarSucursales() async {
    final data = await DatabaseHelper().obtenerSucursales();
    setState(() {
      _sucursales = data;
      if (_sucursales.isNotEmpty) {
        _cargarProductos();
      }
    });
  }

  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
    });

    if (_sucursalSeleccionadaId != null) {
      final data = await DatabaseHelper().obtenerProductosPorSucursal(
        _sucursalSeleccionadaId!,
        _searchController.text.trim(),
        true,
      );
      setState(() {
        _productos = data;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _eliminarProducto(int id) async {
    setState(() {
      _isLoading = true;
    });
    await DatabaseHelper().eliminarProducto(id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownMenu<Sucursal>(
              width: double.infinity,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              label: const Text('Sucursal'),
              onSelected: (Sucursal? val) {
                setState(() {
                  _sucursalSeleccionadaId = val?.id;
                  _cargarProductos();
                });
              },
              dropdownMenuEntries:
                  _sucursales
                      .map(
                        (s) => DropdownMenuEntry<Sucursal>(
                          value: s,
                          label: s.nombre,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
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
                      suffixIcon: _searchController.text.trim().isNotEmpty ? InkWell(
                        borderRadius: BorderRadius.circular(100),
                        radius: 10,
                        onTap: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                          _cargarSucursales();
                        },

                        child: Icon(Icons.clear_rounded),
                      ) : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed:
                      _isLoading || _sucursalSeleccionadaId == null || _productos.isEmpty
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
                : _sucursalSeleccionadaId == null
                ? Expanded(
                  child: Center(
                    child: Text('No se ha seleccionado una sucursal'),
                  ),
                )
                : _productos.isEmpty
                ? Expanded(
                  child: Center(child: Text('No hay productos registrados')),
                )
                : Expanded(
                  child: ProductoList(
                    productos: _productos,
                    reload: _cargarProductos,
                    delete: _eliminarProducto,
                  ),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_sucursalSeleccionadaId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Seleccione una sucursal primero'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                elevation: 5,
              ),
              snackBarAnimationStyle: AnimationStyle(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                reverseCurve: Curves.easeOut,
                reverseDuration: Duration(milliseconds: 500),
              ),
            );
            return;
          }
          final res = await Navigator.pushNamed(
            context,
            '/producto/save',
            arguments: {
              'producto': null,
              'idSucursal': _sucursalSeleccionadaId,
            },
          );
          if (res == true) {
            _cargarProductos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
