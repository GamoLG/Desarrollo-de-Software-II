import 'package:flutter/material.dart';

class Ejercicio3Screen extends StatefulWidget {
  const Ejercicio3Screen({super.key});

  @override
  State<Ejercicio3Screen> createState() => _Ejercicio3ScreenState();
}

class _Ejercicio3ScreenState extends State<Ejercicio3Screen> {
  int _contador = 0;

  void _incrementar() => setState(() => _contador++);
  void _decrementar() => setState(() {
    if (_contador > 0) _contador--;
  });
  void _reiniciar() => setState(() => _contador = 0);

  Color get _colorContador {
    if (_contador == 0) return Colors.grey;
    if (_contador < 5) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Interactivo'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor actual:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: _colorContador,
              ),
              child: Text('$_contador'),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec',
                  onPressed: _decrementar,
                  backgroundColor: Colors.red.shade400,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.extended(
                  heroTag: 'rst',
                  onPressed: _reiniciar,
                  backgroundColor: Colors.grey.shade600,
                  label: const Text('Reset', style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'inc',
                  onPressed: _incrementar,
                  backgroundColor: Colors.green.shade500,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}