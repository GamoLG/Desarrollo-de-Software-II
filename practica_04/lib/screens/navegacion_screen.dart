import 'package:flutter/material.dart';

class NavegacionScreen extends StatelessWidget {
  const NavegacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categoría: Navegación'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pestaña 1'),
              Tab(text: 'Pestaña 2'),
              Tab(text: 'Pestaña 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Contenido de la Pestaña 1 (TabBar)'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Ejemplo de Navigator.push para simular ir a otra pantalla
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Pantalla de Detalle')),
                            body: const Center(child: Text('¡Navegación con Navigator.push exitosa!')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Ir a Pantalla de Detalle'),
                  ),
                ],
              ),
            ),
            const Center(child: Text('Contenido de la Pestaña 2')),
            const Center(child: Text('Contenido de la Pestaña 3')),
          ],
        ),
      ),
    );
  }
}