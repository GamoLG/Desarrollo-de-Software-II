import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  bool _switchValor = false;
  double _sliderValor = 50.0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoría: Input')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Campo de Texto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Escribiste: ${_controller.text}')),
                );
              },
              child: const Text('Procesar Input'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Interruptor (Switch):'),
                Switch(
                  value: _switchValor,
                  onChanged: (val) => setState(() => _switchValor = val),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Slider valor: ${_sliderValor.round()}'),
            Slider(
              value: _sliderValor,
              min: 0,
              max: 100,
              divisions: 10,
              label: _sliderValor.round().toString(),
              onChanged: (val) => setState(() => _sliderValor = val),
            ),
          ],
        ),
      ),
    );
  }
}