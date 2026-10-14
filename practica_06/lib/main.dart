import 'package:flutter/material.dart';
import 'diseno_responsivo.dart';
import 'adaptive_grid.dart';
import 'navegacion_adaptativa.dart';
import 'accesibilidad_semantica.dart';
import 'accesibilidad_interaccion.dart';
import 'checklist_lanzamiento.dart';

void main() {
  runApp(const Practica06App());
}

class Practica06App extends StatefulWidget {
  const Practica06App({super.key});

  @override
  State<Practica06App> createState() => _Practica06AppState();
}

class _Practica06AppState extends State<Practica06App> {
  bool _mostrarSemanticsDebugger = false;

  void _toggleDebugger(bool valor) {
    setState(() => _mostrarSemanticsDebugger = valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 06 - Responsivo y Accesible',
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: _mostrarSemanticsDebugger,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: MenuPrincipal06(
        debuggerActivo: _mostrarSemanticsDebugger,
        onToggleDebugger: _toggleDebugger,
      ),
    );
  }
}

class MenuPrincipal06 extends StatelessWidget {
  final bool debuggerActivo;
  final ValueChanged<bool> onToggleDebugger;

  const MenuPrincipal06({
    super.key,
    required this.debuggerActivo,
    required this.onToggleDebugger,
  });

  @override
  Widget build(BuildContext context) {
    final modulos = [
      {
        'titulo': '1. Diseño Responsivo',
        'sub': 'LayoutBuilder, FractionallySizedBox y Expanded',
        'icono': Icons.aspect_ratio,
        'color': Colors.blue.shade900,
        'pantalla': const DisenoResponsivoScreen(),
      },
      {
        'titulo': '2. Adaptive Grid',
        'sub': 'Columnas automáticas por MaxCrossAxisExtent',
        'icono': Icons.grid_view,
        'color': Colors.indigo.shade800,
        'pantalla': const AdaptiveGridScreen(),
      },
      {
        'titulo': '3. Navegación Adaptativa',
        'sub': 'BottomNavigationBar (móvil) vs NavigationRail (desktop)',
        'icono': Icons.navigation,
        'color': Colors.teal.shade800,
        'pantalla': const NavegacionAdaptativaScreen(),
      },
      {
        'titulo': '4. Semántica y Lectores',
        'sub': 'Semantics, ExcludeSemantics, Merge y Anuncios',
        'icono': Icons.record_voice_over,
        'color': Colors.deepPurple.shade800,
        'pantalla': const AccesibilidadSemanticaScreen(),
      },
      {
        'titulo': '5. Interacción y Foco',
        'sub': 'Touch Targets (≥48px), foco de teclado y contraste',
        'icono': Icons.touch_app,
        'color': Colors.brown.shade800,
        'pantalla': const AccesibilidadInteraccionScreen(),
      },
      {
        'titulo': '6. Checklist de Lanzamiento',
        'sub': 'Lista de validación completa de la Guía 06',
        'icono': Icons.checklist,
        'color': Colors.green.shade800,
        'pantalla': const ChecklistLanzamientoScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Práctica 06: Responsivo y Accesible'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                color: Colors.amber.shade50,
                elevation: 2,
                child: SwitchListTile(
                  title: const Text('Semantics Debugger (Inspector de Accesibilidad)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('Muestra el árbol semántico visible para lectores'),
                  value: debuggerActivo,
                  onChanged: onToggleDebugger,
                ),
              ),
              const SizedBox(height: 12),
              ...modulos.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (item['color'] as Color).withValues(alpha: 0.15),
                      child: Icon(item['icono'] as IconData, color: item['color'] as Color),
                    ),
                    title: Text(item['titulo'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text(item['sub'] as String, style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item['pantalla'] as Widget),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}