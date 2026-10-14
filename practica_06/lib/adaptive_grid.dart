import 'package:flutter/material.dart';

class AdaptiveGridScreen extends StatelessWidget {
  const AdaptiveGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> elementos = List.generate(15, (i) => 'Malla #${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Grid'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Columnas dinámicas según maxCrossAxisExtent: 160px',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: elementos.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      border: Border.all(color: Colors.indigo.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.widgets, color: Colors.indigo.shade700, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          elementos[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}