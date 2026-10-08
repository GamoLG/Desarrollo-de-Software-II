import 'package:flutter/material.dart';

class Ejercicio2Screen extends StatelessWidget {
  const Ejercicio2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarjeta de Perfil'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade200,
                  child: const Icon(Icons.person, size: 70, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'JHOEL ALEX LUICHO QUISPE',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ingeniería Informática y de Sistemas',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const Divider(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Estadistica(valor: '120', etiqueta: 'Proyectos'),
                    Estadistica(valor: '4.8', etiqueta: 'Rating'),
                    Estadistica(valor: '5+', etiqueta: 'Años'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Enviar Mensaje'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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

class Estadistica extends StatelessWidget {
  final String valor;
  final String etiqueta;

  const Estadistica({super.key, required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(etiqueta, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
