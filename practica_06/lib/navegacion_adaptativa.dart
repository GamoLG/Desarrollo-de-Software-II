import 'package:flutter/material.dart';
import 'breakpoints.dart';

class NavegacionAdaptativaScreen extends StatefulWidget {
  const NavegacionAdaptativaScreen({super.key});

  @override
  State<NavegacionAdaptativaScreen> createState() => _NavegacionAdaptativaScreenState();
}

class _NavegacionAdaptativaScreenState extends State<NavegacionAdaptativaScreen> {
  int _indice = 0;

  final List<Widget> _vistas = const [
    Center(child: Text('Vista de Inicio (Adaptable)', style: TextStyle(fontSize: 18))),
    Center(child: Text('Vista de Notificaciones', style: TextStyle(fontSize: 18))),
    Center(child: Text('Vista de Perfil de Usuario', style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    final bool esDesktopOTabletAncha = Breakpoints.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(esDesktopOTabletAncha ? 'Modo Desktop (NavigationRail)' : 'Modo Móvil (BottomNav)'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          if (esDesktopOTabletAncha)
            NavigationRail(
              selectedIndex: _indice,
              onDestinationSelected: (i) => setState(() => _indice = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Inicio')),
                NavigationRailDestination(icon: Icon(Icons.notifications), label: Text('Avisos')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Perfil')),
              ],
            ),
          Expanded(child: _vistas[_indice]),
        ],
      ),
      bottomNavigationBar: esDesktopOTabletAncha
          ? null
          : BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Avisos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}