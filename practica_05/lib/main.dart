import 'package:flutter/material.dart';
import 'ejemplos_guia.dart';
import 'nivel_basico.dart';
import 'nivel_intermedio.dart';
import 'nivel_avanzado.dart';

void main() {
  runApp(const Practica05App());
}

class Practica05App extends StatelessWidget {
  const Practica05App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 05 - Eventos Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MenuPrincipalScreen(),
    );
  }
}

class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modulos = [
      {
        'titulo': 'Ejemplos de la Guía',
        'subtitulo': 'Contador, TextField, Gestos y Mini Proyecto',
        'icono': Icons.menu_book,
        'color': Colors.indigo,
        'pantalla': const EjemplosGuiaScreen(),
      },
      {
        'titulo': 'Nivel Básico',
        'subtitulo': 'Cambio de color, Contador (+/-), Texto reactivo',
        'icono': Icons.filter_1,
        'color': Colors.teal,
        'pantalla': const NivelBasicoScreen(),
      },
      {
        'titulo': 'Nivel Intermedio',
        'subtitulo': 'Formulario con edad, Switch, Doble tap en contenedor',
        'icono': Icons.filter_2,
        'color': Colors.deepPurple,
        'pantalla': const NivelIntermedioScreen(),
      },
      {
        'titulo': 'Nivel Avanzado',
        'subtitulo': 'Lista dinámica, Validación de Form, Juego de Taps',
        'icono': Icons.filter_3,
        'color': Colors.amber.shade900,
        'pantalla': const NivelAvanzadoScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Práctica 05: Eventos e Interactividad'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: modulos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = modulos[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: (item['color'] as Color).withValues(alpha: 0.15),
                child: Icon(item['icono'] as IconData, color: item['color'] as Color),
              ),
              title: Text(
                item['titulo'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(item['subtitulo'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['pantalla'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}