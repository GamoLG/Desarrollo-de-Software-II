import 'package:flutter/material.dart';

class AccesibilidadInteraccionScreen extends StatelessWidget {
  const AccesibilidadInteraccionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interacción y Foco'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Touch Targets mínimos (≥ 44px o 48px)
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Touch Targets (≥ 48px lógicos con SizedBox)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton(
                            style: IconButton.styleFrom(backgroundColor: Colors.grey.shade200),
                            onPressed: () {},
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Cerrar ventana',
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Icono de 24px dentro de un área táctil de 48px.'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Control de foco y navegación por teclado
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Navegación por Teclado y Foco Explícito',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Focus(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Campo 1 (Foco con tabulador)',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown.shade800, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Focus(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Campo 2 (Foco con tabulador)',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown.shade800, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Contraste mínimo WCAG AA (4.5:1)
            Card(
              color: Colors.grey.shade900,
              elevation: 3,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contraste Alto (> 4.5:1)',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Texto claro sobre fondo oscuro garantizando legibilidad según WCAG AA.',
                      style: TextStyle(color: Color(0xFFECEFF1), fontSize: 14),
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