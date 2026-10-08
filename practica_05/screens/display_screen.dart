import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoría: Display')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Ejemplo de Estilos de Texto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          const Text(
            'Este es un texto largo con maxLines configurado para truncar puntos suspensivos si excede el límite permitido.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Soy una Card (Tarjeta elevada con sombra)'),
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text('AB'),
            ),
            title: Text('CircleAvatar de ejemplo'),
            subtitle: Text('Ideal para perfiles o avatares'),
          ),
        ],
      ),
    );
  }
}