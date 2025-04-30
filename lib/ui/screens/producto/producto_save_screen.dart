import 'package:flutter/material.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/producto.dart';

import 'package:proyecto_final/core/database/database_helper.dart';

class ProductoSaveScreen extends StatefulWidget {
  final Producto? producto;
  final int idSucursal;

  const ProductoSaveScreen({
    super.key,
    this.producto,
    required this.idSucursal,
  });

  @override
  State<ProductoSaveScreen> createState() => _ProductoSaveScreenState();
}

class _ProductoSaveScreenState extends State<ProductoSaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _descripcionController.text = widget.producto!.descripcion!;
      _precioController.text = widget.producto!.precio.toString();
      _stockController.text = widget.producto!.stock.toString();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate() ||
        _nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty) {
      return;
    }

    final producto = Producto(
      id: widget.producto?.id,
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      precio: double.tryParse(_precioController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      idSucursal: widget.idSucursal,
    );

    if (widget.producto != null) {
      await DatabaseHelper().actualizarProducto(producto);
      CustomTheme.snackBar(
        context,
        'Producto actualizado con éxito',
        type: SnackBarType.success,
      );
    } else {
      await DatabaseHelper().insertarProducto(producto);
      CustomTheme.snackBar(
        context,
        'Producto guardado con éxito',
        type: SnackBarType.success,
      );
    }
    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
    _stockController.clear();
    Navigator.pop(context, widget.producto != null ? producto : true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTheme.appBar(context, 'Guardar Producto'),
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
                  hintText: 'Nuevo Producto',
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
                controller: _descripcionController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  hintText: 'Descripción del producto',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Precio',
                  prefixIcon: Icon(Icons.attach_money_outlined),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Existencias',
                  border: OutlineInputBorder(),
                  hintText: 'Cantidad de productos a ingresar',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar Producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
