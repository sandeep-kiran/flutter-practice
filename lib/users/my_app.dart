import 'package:flutter/material.dart';
import 'authentication/signup/registration.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData(),
      debugShowCheckedModeBanner: false,
      home: const RegistrationScreen(),
    );
  }
}

ThemeData themeData() {
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
