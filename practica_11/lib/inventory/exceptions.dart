class InsufficientStockException implements Exception {
  final String productId;
  final int available;
  final int requested;

  InsufficientStockException({
    required this.productId,
    required this.available,
    required this.requested,
  });

  @override
  String toString() =>
      'InsufficientStockException: Stock insuficiente para $productId. Solicitado: $requested, Disponible: $available';
}