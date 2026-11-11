class Product {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Coupon {
  final String code;
  final double discountPercent; // Ejemplo: 0.20 para 20%
  final DateTime expirationDate;

  const Coupon({
    required this.code,
    required this.discountPercent,
    required this.expirationDate,
  });

  bool get isValid => DateTime.now().isBefore(expirationDate);
}