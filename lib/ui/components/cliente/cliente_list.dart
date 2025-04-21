import 'package:flutter/material.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/ui/components/cliente/cliente_list_item.dart';


class ClienteList extends StatelessWidget {
  final List<Usuario> clientes;
  final Function reload;

  const ClienteList({super.key, required this.clientes, required this.reload});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        final c = clientes[index];
        return ClienteListItem(
          cliente: c,
          reload: reload,
        );
      },
    );
  }
}
