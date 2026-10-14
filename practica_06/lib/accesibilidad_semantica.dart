import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AccesibilidadSemanticaScreen extends StatefulWidget {
  const AccesibilidadSemanticaScreen({super.key});

  @override
  State<AccesibilidadSemanticaScreen> createState() => _AccesibilidadSemanticaScreenState();
}

class _AccesibilidadSemanticaScreenState extends State<AccesibilidadSemanticaScreen> {
  bool _recordar = false;
  int _contadorProductos = 0;

  void _anunciarCambio() {
    setState(() => _contadorProductos++);
    // Anuncio explícito para TalkBack / VoiceOver sin mover el foco
    SemanticsService.announce(
      'Producto agregado al carrito. Tienes $_contadorProductos productos.',
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semántica y Lectores'),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Semantics y ExcludeSemantics
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semantics y ExcludeSemantics',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // AQUÍ VA EL EJEMPLO DE LA GUÍA (Avatar con Semantics para el lector de pantalla)
                        Semantics(
                          label: 'Foto de perfil de usuario',
                          hint: 'Doble toque para cambiar la foto',
                          button: true,
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.deepPurple.shade200,
                              child: const Icon(Icons.person, color: Colors.white, size: 36),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Y al lado van los iconos decorativos excluidos del lector
                        const Row(
                          children: [
                            ExcludeSemantics(child: Icon(Icons.star, color: Colors.amber)),
                            ExcludeSemantics(child: Icon(Icons.star, color: Colors.amber)),
                            ExcludeSemantics(child: Icon(Icons.star, color: Colors.amber)),
                            SizedBox(width: 6),
                            Text('Estrellas decorativas'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. MergeSemantics
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MergeSemantics (Agrupación en una sola frase)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    MergeSemantics(
                      child: InkWell(
                        onTap: () => setState(() => _recordar = !_recordar),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _recordar,
                              onChanged: (v) => setState(() => _recordar = v ?? false),
                            ),
                            const Text('Recordar contraseña en este dispositivo'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Anuncios dinámicos
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Anuncios Dinámicos (SemanticsService)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Productos en carrito: $_contadorProductos'),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _anunciarCambio,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar y Notificar a TalkBack'),
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