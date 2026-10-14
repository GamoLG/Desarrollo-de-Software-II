import 'package:flutter/material.dart';

class ChecklistLanzamientoScreen extends StatefulWidget {
  const ChecklistLanzamientoScreen({super.key});

  @override
  State<ChecklistLanzamientoScreen> createState() => _ChecklistLanzamientoScreenState();
}

class _ChecklistLanzamientoScreenState extends State<ChecklistLanzamientoScreen> {
  final Map<String, bool> _items = {
    'Sin anchos fijos en los widgets principales': true,
    'Funciona en horizontal y vertical sin overflow': true,
    'Contenido legible en pantallas de 320px a 1440px': true,
    'Grids y listas adaptan sus columnas al ancho': true,
    'Navegación cambia según breakpoint': true,
    'Texto legible con escalado sin bloqueos fijos': true,
    'Contraste de al menos 4.5:1 (WCAG AA)': true,
    'Áreas táctiles (touch targets) de al menos 44px': true,
    'Iconos interactivos con etiqueta Semantics': true,
    'Imágenes decorativas con ExcludeSemantics': true,
    'Cambios dinámicos anunciados para lectores': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist de Lanzamiento'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: _items.keys.map((criterio) {
          return CheckboxListTile(
            title: Text(criterio, style: const TextStyle(fontSize: 14)),
            value: _items[criterio],
            activeColor: Colors.green.shade800,
            onChanged: (val) {
              setState(() => _items[criterio] = val ?? false);
            },
          );
        }).toList(),
      ),
    );
  }
}