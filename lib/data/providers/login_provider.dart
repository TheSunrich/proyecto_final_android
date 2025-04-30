import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/usuario.dart';

class LoginProvider with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  void setUsuario(Usuario? usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void clearUsuario() {
    _usuario = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _usuario != null;
  }

  Color obtenerColorRol() {
    switch (_usuario!.rol) {
      case 'admin':
        return Colors.deepOrange.shade400;
      case 'vendedor':
        return Colors.pink.shade300;
      case 'cliente':
        return Colors.green.shade300;
      default:
        return Colors.grey;
    }
  }
}