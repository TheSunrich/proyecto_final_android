import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';
import 'package:proyecto_final/ui/components/producto/producto_card.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  int? _sucursalSeleccionadaId;
  int? _clienteSeleccionadoId;
  double _total = 0.0;

  List<Sucursal> _sucursales = [];
  List<Usuario> _clientes = [];
  List<Producto> _productos = [];
  Map<int, int> _carrito = {}; // productoId -> cantidad

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    final sucursales = await DatabaseHelper().obtenerSucursales();
    final clientes = await DatabaseHelper().obtenerUsuarios(null, 'cliente');
    setState(() {
      _sucursales = sucursales;
      _clientes = clientes;
      if (_sucursales.isNotEmpty) {
        _sucursalSeleccionadaId ??= _sucursales.first.id;
        _cargarProductos();
      }
    });
  }

  Future<void> _cargarProductos() async {
    if (_sucursalSeleccionadaId == null) return;
    final productos = await DatabaseHelper().obtenerProductosPorSucursal(
      _sucursalSeleccionadaId!,
    );
    setState(() {
      _productos = productos;
      _carrito.clear();
      _total = 0;
    });
  }

  void _actualizarCantidad(int productoId, int cantidad, double precio) {
    setState(() {
      if (cantidad <= 0) {
        _carrito.remove(productoId);
      } else {
        _carrito[productoId] = cantidad;
      }
      _total = _carrito.entries.fold(0, (sum, entry) {
        final producto = _productos.firstWhere((p) => p.id == entry.key);
        return sum + (entry.value * producto.precio);
      });
    });
  }

  Future<void> _guardarVenta() async {
    if (_carrito.isEmpty || _sucursalSeleccionadaId == null) return;


    final venta = Venta(
      idSucursal: _sucursalSeleccionadaId!,
      idCliente: _clienteSeleccionadoId,
      total: _total,
    );

    final idVenta = await DatabaseHelper().insertarVenta(venta);

    for (final entry in _carrito.entries) {
      final producto = _productos.firstWhere((p) => p.id == entry.key);
      final detalle = DetalleVenta(
        idVenta: idVenta,
        idProducto: producto.id!,
        cantidad: entry.value,
        precioUnitario: producto.precio,
      );
      await DatabaseHelper().insertarDetalleVenta(detalle);
      await DatabaseHelper().reducirStock(producto.id!, entry.value);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Venta registrada exitosamente')),
    );

    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Venta'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
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
              hintText: 'Seleccione una sucursal',
              onSelected: (Sucursal? val) {
                setState(() {
                  _sucursalSeleccionadaId = val?.id;
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
            DropdownMenu<Usuario>(
              width: double.infinity,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              label: const Text('Cliente'),
              hintText: 'Seleccione un cliente',
              onSelected: (Usuario? val) {
                setState(() {
                  _clienteSeleccionadoId = val?.id;
                });
              },
              dropdownMenuEntries:
                  _clientes
                      .map(
                        (s) => DropdownMenuEntry<Usuario>(
                          value: s,
                          label: s.nombre,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Productos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                children:
                    _productos.map((producto) {
                      return ProductoCard(
                        producto: producto,
                        cantidad: _carrito[producto.id] ?? 0,
                        actualizarCantidad: _actualizarCantidad,
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text('Total: \$${_total.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: _guardarVenta,
              child: const Text('Confirmar Venta'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
