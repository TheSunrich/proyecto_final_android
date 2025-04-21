import 'package:flutter/material.dart';

import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';

class ClienteSaveScreen extends StatefulWidget {
  final Usuario? cliente;

  const ClienteSaveScreen({super.key, this.cliente});

  @override
  State<ClienteSaveScreen> createState() => _ClienteSaveScreenState();
}

class _ClienteSaveScreenState extends State<ClienteSaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nombreController.text = widget.cliente!.nombre;
      _telefonoController.text = widget.cliente!.telefono!;
      _emailController.text = widget.cliente!.email!;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /*Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate() ||
        _nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty) {
      return;
    }

    final producto = Producto(
      id: widget.cliente?.id,
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      precio: double.tryParse(_precioController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      idSucursal: widget.idSucursal,
    );

    if (widget.cliente != null) {
      await DatabaseHelper().actualizarProducto(producto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto actualizado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await DatabaseHelper().insertarProducto(producto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto guardado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
    _stockController.clear();
    Navigator.pop(context, widget.cliente != null ? producto : true);
  }*/

  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate() ||
        _nombreController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _contrasenaController.text.isEmpty ||
        _emailController.text.isEmpty) {
      return;
    }

    final cliente = Usuario(
      id: widget.cliente?.id,
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      email: _emailController.text,
      contrasena: _contrasenaController.text,
      rol: 'cliente',
    );
    if (widget.cliente != null) {
      await DatabaseHelper().actualizarUsuario(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente actualizado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await DatabaseHelper().insertarUsuario(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente guardado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    _nombreController.clear();
    _telefonoController.clear();
    _emailController.clear();
    _contrasenaController.clear();
    Navigator.pop(context, widget.cliente != null ? cliente : true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardar Cliente'),
        flexibleSpace: CustomTheme.appBarTheme,
      ),
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
                  hintText: 'Nombre completo del cliente',
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
                controller: _telefonoController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  hintText: 'Telefono del cliente',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'usuario@ejemplo.com',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor ingrese un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  hintText: '*********',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    radius: 10,
                    onTap: () {
                      toggleVisibility();
                    },
                    child: Icon(
                      _isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarCliente,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar Cliente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
