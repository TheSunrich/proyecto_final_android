import 'package:flutter/material.dart';
import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/ui/screens/menu_principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _crearUsuarioPorDefecto();
  }

  Future<void> _crearUsuarioPorDefecto() async {
    final usuarios = await DatabaseHelper().obtenerUsuarios();
    if (usuarios.isEmpty) {
      final admin = Usuario(nombre: 'admin', contrasena: 'admin123', rol: 'admin');
      await DatabaseHelper().insertarUsuario(admin);
    }
  }

  Future<void> _login() async {
    final usuario = await DatabaseHelper().validarLogin(
      _usuarioController.text,
      _contrasenaController.text,
    );

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPrincipalScreen(usuario: usuario),
        ),
      );
    } else {
      setState(() {
        _error = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Ingresar'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
