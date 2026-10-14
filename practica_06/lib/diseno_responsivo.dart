import 'package:flutter/material.dart';

class DisenoResponsivoScreen extends StatelessWidget {
  const DisenoResponsivoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double anchoTotal = MediaQuery.sizeOf(context).width;
    final bool esHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseño Responsivo'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info MediaQuery
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'MediaQuery: Ancho = ${anchoTotal.toStringAsFixed(1)}px | Orientación: ${esHorizontal ? "Horizontal" : "Vertical"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. LayoutBuilder
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LayoutBuilder (Toma decisiones por contenedor)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool usarFila = constraints.maxWidth > 550;

                        final itemA = Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Bloque A (Flexible)'),
                        );

                        final itemB = Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.cyan.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Bloque B (Flexible)'),
                        );

                        if (usarFila) {
                          return Row(
                            children: [
                              Expanded(flex: 2, child: itemA),
                              const SizedBox(width: 10),
                              Expanded(flex: 3, child: itemB),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              itemA,
                              const SizedBox(height: 10),
                              itemB,
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. FractionallySizedBox
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FractionallySizedBox (80% del ancho del padre)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: const Text('Botón al 80% (Sin píxeles fijos)'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Row con Expanded proporcional (flex 2 y 1)
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expanded con flex (2/3 y 1/3)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              child: const Text('Buscar'),
                            ),
                          ),
                        ),
                      ],
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