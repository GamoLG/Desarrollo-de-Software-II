import 'dart:async';
import 'package:flutter/material.dart';

class NivelAvanzadoScreen extends StatefulWidget {
  const NivelAvanzadoScreen({super.key});

  @override
  State<NivelAvanzadoScreen> createState() => _NivelAvanzadoScreenState();
}

class _NivelAvanzadoScreenState extends State<NivelAvanzadoScreen> {
  final List<String> _tareas = ['Estudiar Flutter', 'Implementar eventos'];
  final TextEditingController _itemCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _correoCtrl = TextEditingController();

  int _tapsJuego = 0;
  int _tiempoRestante = 10;
  bool _juegoEnCurso = false;
  Timer? _timer;

  void _agregarItem() {
    if (_itemCtrl.text.trim().isNotEmpty) {
      setState(() {
        _tareas.add(_itemCtrl.text.trim());
        _itemCtrl.clear();
      });
    }
  }

  void _iniciarJuego() {
    setState(() {
      _tapsJuego = 0;
      _tiempoRestante = 10;
      _juegoEnCurso = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiempoRestante > 1) {
        setState(() => _tiempoRestante--);
      } else {
        timer.cancel();
        setState(() {
          _tiempoRestante = 0;
          _juegoEnCurso = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _itemCtrl.dispose();
    _correoCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios Nivel Avanzado'),
        backgroundColor: Colors.amber.shade900,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('7. Lista Dinámica (Agregar Elementos)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _itemCtrl,
                            decoration: const InputDecoration(hintText: 'Nuevo elemento...', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green, size: 36),
                          onPressed: _agregarItem,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(_tareas[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => _tareas.removeAt(index)),
                        ),
                      ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text('8. Validación de Formulario', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _correoCtrl,
                        decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'El campo no puede estar vacío';
                          if (!value.contains('@') || !value.contains('.')) return 'Ingresa un correo válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('¡Formulario validado con éxito!')),
                            );
                          }
                        },
                        child: const Text('Validar'),
                      ),
                    ],
                  ),
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
                    const Text('9. Mini Juego: Contador de Taps', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Tiempo: $_tiempoRestante s | Taps: $_tapsJuego',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 10),
                    if (!_juegoEnCurso)
                      ElevatedButton(
                        onPressed: _iniciarJuego,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade900, foregroundColor: Colors.white),
                        child: Text(_tiempoRestante == 0 ? 'Jugar de nuevo' : 'Iniciar Reto (10s)'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => setState(() => _tapsJuego++),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('¡TAP AQUÍ!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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