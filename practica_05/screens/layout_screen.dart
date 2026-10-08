import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoría: Layout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Container:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Caja con padding y decoración')),
            ),
            const SizedBox(height: 16),
            const Text('Row (Horizontal):', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.star, color: Colors.amber),
                Text('Texto en fila'),
                Icon(Icons.favorite, color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Stack (Superposición):', style: TextStyle(fontWeight: FontWeight.bold)),
            Stack(
              children: [
                Container(height: 120, color: Colors.grey.shade300),
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: Chip(label: Text('Overlay / Posicionado')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}