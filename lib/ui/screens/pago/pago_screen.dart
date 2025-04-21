import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';
import 'package:proyecto_final/ui/components/pago/pago_list.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  int? _clienteSeleccionadoId;

  List<Usuario> _clientes = [];
  List<Venta> _ventas = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final clientes = await DatabaseHelper().obtenerUsuarios(null, 'cliente');
    setState(() {
      _clientes = clientes;
      _cargarVentas();
    });
  }

  Future<void> _cargarVentas() async {
    setState(() {
      _isLoading = true;
    });
    if (_clienteSeleccionadoId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final ventas = await DatabaseHelper().obtenerVentasPorCliente(
      _clienteSeleccionadoId!,
    );
    setState(() {
      _ventas = ventas;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar pago de carrito'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                  _cargarVentas();
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
            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _ventas.isEmpty
                ? const Expanded(
                  child: Center(child: Text('No se encontraron ventas realizadas')),
                )
                : Expanded(
                  child: PagoList(ventas: _ventas, reload: _cargarVentas),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
