import 'package:flutter/material.dart';

class FeedbackNavigationScreen extends StatelessWidget {
  const FeedbackNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoría: Feedback y Alertas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CÍRCULO GIRATORIO (Indeterminado: value se omite o es null)
            const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.indigo,
                  strokeWidth: 4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Círculo de progreso giratorio (Animado)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // Botón para SnackBar
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Esto es un SnackBar flotante!')),
                );
              },
              child: const Text('Mostrar SnackBar'),
            ),
            const SizedBox(height: 16),

            // Botón para AlertDialog
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Alerta de Confirmación'),
                    content: const Text('¿Estás seguro de continuar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Mostrar AlertDialog'),
            ),
            const SizedBox(height: 16),

            // Chips
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Chip Básico')),
                Chip(
                  avatar: CircleAvatar(child: Text('F')),
                  label: Text('Flutter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}