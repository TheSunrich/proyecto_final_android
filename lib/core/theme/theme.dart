import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/data/providers/login_provider.dart';

enum SnackBarType { error, success, info, warning }

class CustomTheme {
  static Container appBarTheme = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[Colors.indigo, Colors.indigo.shade300],
      ),
    ),
  );

  static AppBar appBar(
    BuildContext context,
    String text, {
    PreferredSizeWidget? bottom,
  }) {
    final loggedUser = context.read<LoginProvider>().usuario!;
    final color = context.read<LoginProvider>().obtenerColorRol();

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          CircleAvatar(
            backgroundColor: color,
            child: Text(
              loggedUser.nombre[0].toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      centerTitle: true,
      elevation: 5,
      flexibleSpace: appBarTheme,
      bottom: bottom,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    BuildContext context,
    String text, {
    SnackBarType? type,
  }) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      backgroundColor:
          type == SnackBarType.error
              ? Colors.red
              : type == SnackBarType.success
              ? Colors.green
              : type == SnackBarType.info
              ? Colors.blue
              : Colors.blueGrey,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 2,
      behavior: SnackBarBehavior.floating,

    ),
    snackBarAnimationStyle: AnimationStyle(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 750),
      reverseCurve: Curves.easeOut,
      reverseDuration: Duration(milliseconds: 750),
    ),

  );

  static FloatingActionButton floatingActionButton(
    BuildContext context, {
    required Function() onPressed,
    required Icon icon,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: icon,
    );
  }
}
