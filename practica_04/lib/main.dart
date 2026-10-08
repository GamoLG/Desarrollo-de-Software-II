import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importamos la pantalla principal que creamos en la carpeta screens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 04 - Widgets Flutter',
      // Ocultamos la etiqueta de "Debug" en la esquina superior derecha
      debugShowCheckedModeBanner: false,
      // Configuramos el tema general con Material 3 y un color base (SeedColor)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Definimos cuál será la primera pantalla que verá el usuario al abrir la app
      home: const HomeScreen(),
    );
  }
}