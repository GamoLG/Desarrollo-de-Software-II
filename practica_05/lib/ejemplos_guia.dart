import 'package:flutter/material.dart';

class EjemplosGuiaScreen extends StatefulWidget {
  const EjemplosGuiaScreen({super.key});

  @override
  State<EjemplosGuiaScreen> createState() => _EjemplosGuiaScreenState();
}

class _EjemplosGuiaScreenState extends State<EjemplosGuiaScreen> {
  int _contador = 0;
  String _nombre = '';
  String _ultimoGesto = 'Ninguno';
  Color _colorGesto = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplos de la Guía 05'),
        backgroundColor: Colors.indigo,
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
                    const Text('Ejemplo 1: Botón interactivo (onPressed)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Valor: $_contador',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _contador++),
                      icon: const Icon(Icons.add),
                      label: const Text('Incrementar'),
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
                    const Text('Mini Proyecto: Formulario reactivo (onChanged)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingresa tu nombre',
                      ),
                      onChanged: (valor) => setState(() => _nombre = valor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _nombre.isEmpty ? 'Escribe tu nombre arriba' : 'Hola, $_nombre',
                      style: const TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.bold),
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
                    const Text('Ejemplo 3: Manejo de Gestos (GestureDetector)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Gesto detectado: $_ultimoGesto',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _ultimoGesto = 'Tap simple detectado';
                          _colorGesto = Colors.blue;
                        });
                      },
                      onDoubleTap: () {
                        setState(() {
                          _ultimoGesto = 'Doble tap detectado';
                          _colorGesto = Colors.purple;
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          _ultimoGesto = 'Presión larga detectada';
                          _colorGesto = Colors.orange;
                        });
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _colorGesto,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Tócame\n(Tap, Doble, Long)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
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