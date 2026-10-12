import 'dart:math';
import 'package:flutter/material.dart';

class NivelBasicoScreen extends StatefulWidget {
  const NivelBasicoScreen({super.key});

  @override
  State<NivelBasicoScreen> createState() => _NivelBasicoScreenState();
}

class _NivelBasicoScreenState extends State<NivelBasicoScreen> {
  Color _colorFondo = Colors.grey.shade100;
  int _contador = 0;
  final TextEditingController _controladorTexto = TextEditingController();
  String _textoMostrado = '';

  void _cambiarColorFondo() {
    final random = Random();
    setState(() {
      _colorFondo = Color.fromARGB(
        255,
        random.nextInt(200) + 55,
        random.nextInt(200) + 55,
        random.nextInt(200) + 55,
      );
    });
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondo,
      appBar: AppBar(
        title: const Text('Ejercicios Nivel Básico'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('1. Botón que cambia el color de fondo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: _cambiarColorFondo,
                      icon: const Icon(Icons.palette),
                      label: const Text('Cambiar Color'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('2. Contador con botones (+) y (-)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('$_contador',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _contador > 0 ? Colors.green : (_contador < 0 ? Colors.red : Colors.grey),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => _contador--),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => setState(() => _contador++),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade500, foregroundColor: Colors.white),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('3. Capturar texto y mostrar en pantalla',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controladorTexto,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Escribe algo aquí...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _textoMostrado = _controladorTexto.text;
                        });
                      },
                      child: const Text('Mostrar Texto'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _textoMostrado.isEmpty ? '(Presiona el botón para mostrar)' : 'Texto: $_textoMostrado',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}