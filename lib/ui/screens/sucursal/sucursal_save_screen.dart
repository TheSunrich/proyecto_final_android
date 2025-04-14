import 'package:flutter/material.dart';

import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/core/database/database_helper.dart';

class SucursalSaveScreen extends StatefulWidget {
  final Sucursal? sucursal;

  const SucursalSaveScreen({super.key, this.sucursal});

  @override
  State<SucursalSaveScreen> createState() => _SucursalSaveScreenState();
}

class _SucursalSaveScreenState extends State<SucursalSaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.sucursal);
    if (widget.sucursal != null) {
      _nombreController.text = widget.sucursal!.nombre;
      _ubicacionController.text = widget.sucursal!.ubicacion;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  Future<void> _guardarSucursal() async {
    print('${_nombreController.text} ${_nombreController.text.trim().isEmpty}');
    print(
      '${_ubicacionController.text} ${_ubicacionController.text.trim().isEmpty}',
    );
    if (!_formKey.currentState!.validate() ||
        _nombreController.text.trim().isEmpty ||
        _ubicacionController.text.trim().isEmpty) {
      return;
    }
    final sucursal = Sucursal(
      id: widget.sucursal?.id,
      nombre: _nombreController.text,
      ubicacion: _ubicacionController.text,
    );

    if (widget.sucursal != null) {
      await DatabaseHelper().actualizarSucursal(sucursal);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sucursal actualizada con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await DatabaseHelper().insertarSucursal(sucursal);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sucursal guardada con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    _nombreController.clear();
    _ubicacionController.clear();
    Navigator.pop(context, widget.sucursal != null ? sucursal : true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guardar Sucursal')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Nueva Sucursal',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Ubicación',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Ubicación de la sucursal',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _guardarSucursal(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
