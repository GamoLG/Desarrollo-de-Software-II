import 'package:flutter/material.dart';

class NivelIntermedioScreen extends StatefulWidget {
  const NivelIntermedioScreen({super.key});

  @override
  State<NivelIntermedioScreen> createState() => _NivelIntermedioScreenState();
}

class _NivelIntermedioScreenState extends State<NivelIntermedioScreen> {
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _edadCtrl = TextEditingController();
  String _resumenFormulario = '';
  bool _switchActivo = false;
  Color _colorCaja = Colors.deepPurple;
  int _dobleClics = 0;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios Nivel Intermedio'),
        backgroundColor: Colors.deepPurple,
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
                    const Text('4. Formulario con Nombre y Edad',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _edadCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Edad', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _resumenFormulario = 'Usuario: ${_nombreCtrl.text} | Edad: ${_edadCtrl.text} años';
                        });
                      },
                      child: const Text('Procesar Datos'),
                    ),
                    if (_resumenFormulario.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(_resumenFormulario, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('5. Switch (Encendido / Apagado)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Estado: ${_switchActivo ? "ENCENDIDO" : "APAGADO"}',
                            style: TextStyle(
                              color: _switchActivo ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    Switch(
                      value: _switchActivo,
                      onChanged: (nuevoValor) => setState(() => _switchActivo = nuevoValor),
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
                    const Text('6. Detectar Doble Clic en un Contenedor', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Doble toques: $_dobleClics'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _dobleClics++;
                          _colorCaja = _colorCaja == Colors.deepPurple ? Colors.amber.shade800 : Colors.deepPurple;
                        });
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(color: _colorCaja, borderRadius: BorderRadius.circular(16)),
                        alignment: Alignment.center,
                        child: const Text(
                          '¡Haz Doble Clic!',
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