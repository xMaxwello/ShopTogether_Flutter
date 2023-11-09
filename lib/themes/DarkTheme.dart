import 'package:flutter/material.dart';

class DarkTheme {

  static ThemeData getDarkTheme() {

    return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
        useMaterial3: true
    );
  }
}