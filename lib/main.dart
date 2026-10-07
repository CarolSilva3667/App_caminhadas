import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const AppCaminhadas());
}

class AppCaminhadas extends StatefulWidget {
  const AppCaminhadas({super.key});

  @override
  State<AppCaminhadas> createState() => _AppCaminhadasState();
}

class _AppCaminhadasState extends State<AppCaminhadas> {
  bool temaEscuro = false;

  void alternarTema() {
    setState(() {
      temaEscuro = !temaEscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,

        primaryColor: const Color(0xFF6A0019),

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6A0019),
          foregroundColor: Colors.white,
        ),

        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A0019),
          brightness: Brightness.light,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6A0019),
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A0019),
            foregroundColor: Colors.white,
          ),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: Colors.black,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF40000F),
          foregroundColor: Colors.white,
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A0019),
          brightness: Brightness.dark,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6A0019),
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A0019),
            foregroundColor: Colors.white,
          ),
        ),
      ),

      themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,

      home: SplashScreen(alternarTema: alternarTema),
    );
  }
}