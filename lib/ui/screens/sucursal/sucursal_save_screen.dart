import 'package:flutter/material.dart';

class SucursalSaveScreen extends StatefulWidget {
  const SucursalSaveScreen({super.key});

  @override
  State<SucursalSaveScreen> createState() => _SucursalSaveScreenState();
}

class _SucursalSaveScreenState extends State<SucursalSaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardar Sucursal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar la sucursal
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
