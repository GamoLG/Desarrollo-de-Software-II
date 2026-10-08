import 'package:flutter/material.dart';
import 'ejercicio1.dart';
import 'ejercicio2.dart';
import 'ejercicio3.dart';
import 'calculadora.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 1 Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 1 - Menú Completo'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Ejercicio1Screen())),
              child: const Text('Ejercicio 1: Hola Flutter'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Ejercicio2Screen())),
              child: const Text('Ejercicio 2: Tarjeta de Perfil'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Ejercicio3Screen())),
              child: const Text('Ejercicio 3: Contador Interactivo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                backgroundColor: Colors.indigo.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculadoraScreen())),
              child: const Text('Ejercicio 6: Calculadora (Propuesto)'),
            ),
          ],
        ),
      ),
    );
  }
}