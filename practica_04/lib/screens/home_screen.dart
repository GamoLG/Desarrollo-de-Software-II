import 'package:flutter/material.dart';
import 'layout_screen.dart';
import 'display_screen.dart';
import 'input_screen.dart';
import 'navegacion_screen.dart'; // <-- Nueva pantalla de Navegación
import 'feedback_navigation_screen.dart'; // <-- Pantalla de Feedback

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guía Práctica de Widgets - 5 Categorías'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Selecciona una Categoría de la Guía:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _BotonCategoria(
            titulo: '1. Layout (Diseño y Estructura)',
            subtitulo: 'Container, Row, Column, Stack, Expanded...',
            icono: Icons.dashboard,
            color: Colors.blue,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LayoutScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _BotonCategoria(
            titulo: '2. Display (Presentación de Datos)',
            subtitulo: 'Text, Image, Card, CircleAvatar, ListView...',
            icono: Icons.visibility,
            color: Colors.green,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DisplayScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _BotonCategoria(
            titulo: '3. Input (Entrada de Usuario)',
            subtitulo: 'TextField, ElevatedButton, Switch, Slider...',
            icono: Icons.input,
            color: Colors.orange,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _BotonCategoria(
            titulo: '4. Navegación (Rutas y Pestañas)',
            subtitulo: 'AppBar, TabBar, TabBarView, Navigator...',
            icono: Icons.navigation,
            color: Colors.purple,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavegacionScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _BotonCategoria(
            titulo: '5. Feedback (Alertas y Progreso)',
            subtitulo: 'SnackBar, AlertDialog, Círculo giratorio, Chip...',
            icono: Icons.feedback,
            color: Colors.redAccent,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackNavigationScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonCategoria extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback onPressed;

  const _BotonCategoria({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icono, color: Colors.white),
        ),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed,
      ),
    );
  }
}