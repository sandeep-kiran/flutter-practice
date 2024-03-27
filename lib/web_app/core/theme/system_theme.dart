import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(elevation: 5, centerTitle: true),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      activeIndicatorBorder: const BorderSide(
        color: Colors.deepPurple,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );
}
