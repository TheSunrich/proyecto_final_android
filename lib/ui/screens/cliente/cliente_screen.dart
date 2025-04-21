import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/ui/components/cliente/cliente_list.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _searchController = TextEditingController();

  bool _isLoading = false;
  List<Usuario> _clientes = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    setState(() {
      _isLoading = true;
    });
    final data = await DatabaseHelper().obtenerUsuarios(
      _searchController.text.trim(),
      'cliente',
    );
    setState(() {
      _isLoading = false;
      _clientes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
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
              child: ClienteList(clientes: _clientes, reload: _cargarClientes),
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
