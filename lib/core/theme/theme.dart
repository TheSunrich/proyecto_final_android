import 'package:flutter/material.dart';

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
}
