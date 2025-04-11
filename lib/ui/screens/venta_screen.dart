import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/data/models/cliente.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/ui/components/bottom_nav_bar.dart';


class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  int? _sucursalSeleccionadaId;
  int? _clienteSeleccionadoId;
  String _metodoPago = 'Efectivo';
  double _total = 0.0;

  List<Sucursal> _sucursales = [];
  List<Cliente> _clientes = [];
  List<Producto> _productos = [];
  Map<int, int> _carrito = {}; // productoId -> cantidad

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    final sucursales = await DatabaseHelper().obtenerSucursales();
    final clientes = await DatabaseHelper().obtenerClientes();
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
    final productos = await DatabaseHelper().obtenerProductosPorSucursal(_sucursalSeleccionadaId!);
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
    if (_carrito.isEmpty || _sucursalSeleccionadaId == null || _metodoPago.isEmpty) return;

    final ahora = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final venta = Venta(
      fecha: ahora,
      idSucursal: _sucursalSeleccionadaId!,
      idCliente: _clienteSeleccionadoId,
      metodoPago: _metodoPago,
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
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: _sucursalSeleccionadaId,
              hint: const Text('Selecciona sucursal'),
              isExpanded: true,
              items: _sucursales.map((s) {
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
            DropdownButton<int>(
              value: _clienteSeleccionadoId,
              hint: const Text('Selecciona cliente'),
              isExpanded: true,
              items: _clientes.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.nombre),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _clienteSeleccionadoId = val;
                });
              },
            ),
            DropdownButton<String>(
              value: _metodoPago,
              isExpanded: true,
              items: ['Efectivo', 'Tarjeta', 'PayPal'].map((m) {
                return DropdownMenuItem<String>(
                  value: m,
                  child: Text(m),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _metodoPago = val!;
                });
              },
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Productos', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                children: _productos.map((producto) {
                  final cantidad = _carrito[producto.id] ?? 0;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${producto.precio}'),
                          Text('Stock: ${producto.stock}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (cantidad > 0) {
                                    _actualizarCantidad(producto.id!, cantidad - 1, producto.precio);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text('$cantidad'),
                              IconButton(
                                onPressed: () {
                                  if (cantidad < producto.stock) {
                                    _actualizarCantidad(producto.id!, cantidad + 1, producto.precio);
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
