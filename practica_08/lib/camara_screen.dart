import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CamaraScreen extends StatefulWidget {
  const CamaraScreen({super.key});

  @override
  State<CamaraScreen> createState() => _CamaraScreenState();
}

class _CamaraScreenState extends State<CamaraScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imagenSeleccionada;

  Future<void> _capturarFoto(ImageSource origen) async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: origen,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (foto != null) {
        setState(() {
          _imagenSeleccionada = File(foto.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y Galería'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _imagenSeleccionada != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _imagenSeleccionada!,
                    fit: BoxFit.cover,
                    width: 280,
                    height: 280,
                  ),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Sin imagen capturada', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => _capturarFoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tomar Foto'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => _capturarFoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('De Galería'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}