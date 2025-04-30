import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/theme/theme.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';

class ClienteSaveScreen extends StatefulWidget {
  final Usuario? cliente;

  const ClienteSaveScreen({super.key, this.cliente});

  @override
  State<ClienteSaveScreen> createState() => _ClienteSaveScreenState();
}

class _ClienteSaveScreenState extends State<ClienteSaveScreen> {
  Usuario? get _cliente => widget.cliente;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (_cliente != null) {
      _nombreController.text = _cliente!.nombre;
      _telefonoController.text = _cliente!.telefono!;
      _emailController.text = _cliente!.email!;
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

  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate() ||
        _nombreController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _contrasenaController.text.isEmpty ||
        _emailController.text.isEmpty) {
      return;
    }

    final cliente = Usuario(
      id: _cliente?.id,
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      email: _emailController.text,
      contrasena: _contrasenaController.text,
      rol: 'cliente',
    );
    if (_cliente != null) {
      await DatabaseHelper().actualizarUsuario(cliente);
      CustomTheme.snackBar(
        context,
        'Cliente actualizado con éxito',
        type: SnackBarType.success,
      );
    } else {
      await DatabaseHelper().insertarUsuario(cliente);
      CustomTheme.snackBar(
        context,
        'Cliente guardado con éxito',
        type: SnackBarType.success,
      );
    }
    _nombreController.clear();
    _telefonoController.clear();
    _emailController.clear();
    _contrasenaController.clear();
    Navigator.pop(context, _cliente != null ? cliente : true);
  }

  void _toggleCliente() async {
    if (_cliente!.isActive) {
      await DatabaseHelper().eliminarUsuario(_cliente!.id!);
      CustomTheme.snackBar(
        context,
        'Cliente eliminado con éxito',
        type: SnackBarType.success,
      );
    } else {
      await DatabaseHelper().reactivarUsuario(_cliente!.id!);
      CustomTheme.snackBar(
        context,
        'Cliente reactivado con éxito',
        type: SnackBarType.success,
      );
    }
    Navigator.pop(context, _cliente ?? true);
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = context.read<LoginProvider>().usuario!;

    return Scaffold(
      appBar: CustomTheme.appBar(context, 'Guardar Cliente'),
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
              const SizedBox(height: 16),
              _cliente != null && loggedUser.rol == 'admin'
                  ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _toggleCliente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _cliente != null && _cliente!.isActive
                                ? Colors.red
                                : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _cliente!.isActive
                            ? 'Eliminar Cliente'
                            : 'Reactivar Cliente',
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
