import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/cliente.dart';
import 'package:proyecto_final/ui/components/navbar/bottom_nav_bar.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final data = await DatabaseHelper().obtenerClientes();
    setState(() {
      _clientes = data;
    });
  }

  Future<void> _guardarCliente() async {
    if (_nombreController.text.isEmpty || _emailController.text.isEmpty) return;
    final cliente = Cliente(
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      email: _emailController.text,
    );
    await DatabaseHelper().insertarCliente(cliente);
    _nombreController.clear();
    _telefonoController.clear();
    _emailController.clear();
    _cargarClientes();
  }

  Future<void> _eliminarCliente(int id) async {
    await DatabaseHelper().eliminarCliente(id);
    _cargarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _guardarCliente,
              child: const Text('Guardar Cliente'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (context, index) {
                  final cliente = _clientes[index];
                  return ListTile(
                    title: Text(cliente.nombre),
                    subtitle: Text('${cliente.telefono} • ${cliente.email}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _eliminarCliente(cliente.id!),
                    ),
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
