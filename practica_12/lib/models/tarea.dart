class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final String? fotoUrl;
  final DateTime fecha;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    this.fotoUrl,
    required this.fecha,
  });

  factory Tarea.fromMap(String id, Map<String, dynamic> data) {
    return Tarea(
      id: id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      completada: data['completada'] ?? false,
      fotoUrl: data['fotoUrl'],
      fecha: data['fecha'] != null
          ? DateTime.parse(data['fecha'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada,
      'fotoUrl': fotoUrl,
      'fecha': fecha.toIso8601String(),
    };
  }
}