import 'package:flutter/material.dart';
import 'registro_screen.dart';
import 'inventario_screen.dart';

void main() {
  runApp(const Practica07App());
}

class Practica07App extends StatelessWidget {
  const Practica07App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 07 - Formularios y Validaciones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MenuPrincipal07(),
    );
  }
}

class MenuPrincipal07 extends StatelessWidget {
  const MenuPrincipal07({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Práctica 07: Formularios y Datos'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(Icons.how_to_reg, color: Colors.indigo.shade900),
                    ),
                    title: const Text(
                      'Ejercicio 1: Registro Avanzado',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: const Text(
                      'Form, RegEx (email/password), validación cruzada y términos.',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegistroScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(Icons.inventory, color: Colors.teal.shade900),
                    ),
                    title: const Text(
                      'Ejercicio 2: Inventario (CRUD Dinámico)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: const Text(
                      'Modelo Producto, Dropdown, cálculo de subtotal y lista dinámica.',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InventarioScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}