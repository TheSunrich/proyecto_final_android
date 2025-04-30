import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';
import 'package:proyecto_final/ui/components/cliente/cliente_list.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _searchController = TextEditingController();
  late final Usuario _loggedUser = context.read<LoginProvider>().usuario!;

  bool _isLoading = false;
  List<Usuario> _clientes = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarClientes() async {
    setState(() {
      _isLoading = true;
    });
    final data = await DatabaseHelper().obtenerUsuarios(
      search: _searchController.text.trim(),
      rol: 'cliente',
      isActive: _loggedUser.rol == 'admin' ? null : true,
    );
    setState(() {
      _isLoading = false;
      _clientes = data;
    });
  }

  void _toggleCliente(int id, bool isActive) async {
    if(isActive) {
      await DatabaseHelper().eliminarUsuario(id);
      CustomTheme.snackBar(
        context,
        'Cliente eliminado con éxito',
        type: SnackBarType.success,
      );
    } else {
      await DatabaseHelper().reactivarUsuario(id);
      CustomTheme.snackBar(
        context,
        'Cliente reactivado con éxito',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTheme.appBar(context, 'Clientes'),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                      suffixIcon:
                          _searchController.text.trim().isNotEmpty
                              ? InkWell(
                                borderRadius: BorderRadius.circular(100),
                                radius: 10,
                                onTap: () {
                                  _searchController.clear();
                                  FocusScope.of(context).unfocus();
                                  _cargarClientes();
                                },

                                child: Icon(Icons.clear_rounded),
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed:
                      _isLoading || _clientes.isEmpty ? null : _cargarClientes,
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
            const SizedBox(height: 24),
            Expanded(
              child: ClienteList(
                clientes: _clientes,
                reload: _cargarClientes,
                delete: _toggleCliente,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.pushNamed(context, '/cliente/save');
          if (res == true) {
            _cargarClientes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
