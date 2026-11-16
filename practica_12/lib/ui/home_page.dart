import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/tarea.dart';
import '../repositories/tarea_repository.dart';
import '../services/auth_service.dart';
import '../services/archivo_service.dart';
import '../services/clima_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  final _repo = TareaRepository();
  final _archivoService = ArchivoService();
  final _climaService = ClimaService();
  final _picker = ImagePicker();

  Future<void> _mostrarDialogoNuevaTarea() async {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    File? imagenSeleccionada;
    bool guardando = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('Nueva Entrada / Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 12),
                if (imagenSeleccionada != null)
                  Image.file(imagenSeleccionada!, height: 120, fit: BoxFit.cover),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 75,
                    );
                    if (picked != null) {
                      setModalState(() => imagenSeleccionada = File(picked.path));
                    }
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Adjuntar Foto (Supabase)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: guardando ? null : () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: guardando
                  ? null
                  : () async {
                if (tituloCtrl.text.trim().isEmpty) return;
                setModalState(() => guardando = true);
                try {
                  final uid = _auth.currentUser!.uid;
                  String? urlFoto;
                  if (imagenSeleccionada != null) {
                    urlFoto = await _archivoService.subirFoto(
                      imagenSeleccionada!,
                      uid,
                    );
                  }
                  await _repo.agregarTarea(
                    uid,
                    Tarea(
                      id: '',
                      titulo: tituloCtrl.text.trim(),
                      descripcion: descCtrl.text.trim(),
                      fotoUrl: urlFoto,
                      fecha: DateTime.now(),
                    ),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  setModalState(() => guardando = false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al guardar: $e')),
                    );
                  }
                }
              },
              child: guardando
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user.email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _auth.cerrarSesion(),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<ClimaData>(
            future: _climaService.obtenerClimaCusco(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LinearProgressIndicator();
              }
              final clima = snapshot.data!;
              return Container(
                width: double.infinity,
                color: Colors.teal.shade50,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Clima en Cusco (API REST): ${clima['temperature_2m']} °C | Viento: ${clima['wind_speed_10m']} km/h',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<Tarea>>(
              stream: _repo.observarTareas(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tareas = snapshot.data ?? [];
                if (tareas.isEmpty) {
                  return const Center(
                    child: Text('No hay entradas aún. Pulsa + para crear una.'),
                  );
                }
                return ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final t = tareas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: t.fotoUrl != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            t.fotoUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(Icons.note_alt_outlined, size: 40),
                        title: Text(
                          t.titulo,
                          style: TextStyle(
                            decoration: t.completada
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(t.descripcion),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: t.completada,
                              onChanged: (_) => _repo.alternarEstado(user.uid, t),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _repo.eliminarTarea(user.uid, t.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaTarea,
        child: const Icon(Icons.add),
      ),
    );
  }
}