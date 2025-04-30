import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/venta.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';
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

  late final Usuario _loggedUser = context.read<LoginProvider>().usuario!;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_loggedUser.rol == 'cliente') {
      _clienteSeleccionadoId = _loggedUser.id;
      _cargarVentas();
    } else {
      _cargarDatos();
    }
  }

  Future<void> _cargarDatos() async {
    final clientes = await DatabaseHelper().obtenerUsuarios(
      rol: 'cliente',
      isActive: true,
    );
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
      appBar: CustomTheme.appBar(context, 'Realizar Pago de Carrito'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _loggedUser.rol != 'cliente'
                ? DropdownMenu<Usuario>(
                  width: double.infinity,
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    isDense: true,
                    constraints: BoxConstraints(
                      maxHeight: 50,
                    ),
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
                )
                : const SizedBox.shrink(),
            const SizedBox(height: 12),
            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _ventas.isEmpty
                ? const Expanded(
                  child: Center(
                    child: Text('No se encontraron ventas realizadas'),
                  ),
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
