import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArchivoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> subirFoto(File archivo, String uid) async {
    final nombreArchivo = '$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage.from('fotos').upload(
      nombreArchivo,
      archivo,
      fileOptions: const FileOptions(upsert: true),
    );
    return _supabase.storage.from('fotos').getPublicUrl(nombreArchivo);
  }
}