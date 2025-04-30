import 'package:flutter/material.dart';
import 'package:proyecto_final/core/theme/theme.dart';

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
      CustomTheme.snackBar(
        context,
        'Sucursal actualizada con éxito',
        type: SnackBarType.success,
      );
    } else {
      await DatabaseHelper().insertarSucursal(sucursal);
      CustomTheme.snackBar(
        context,
        'Sucursal guardada con éxito',
        type: SnackBarType.success,
      );
    }
    _nombreController.clear();
    _ubicacionController.clear();
    Navigator.pop(context, widget.sucursal != null ? sucursal : true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTheme.appBar(context, 'Guardar Sucursal'),
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
