class Producto {
  final String id;
  final String nombre;
  final int cantidad;
  final double precio;
  final String categoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.categoria,
  });

  double get subtotal => cantidad * precio;

  Producto copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precio,
    String? categoria,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
      'precio': precio,
      'categoria': categoria,
    };
  }
}