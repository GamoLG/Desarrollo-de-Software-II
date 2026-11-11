import 'exceptions.dart';
import 'models.dart';
import 'services.dart';

class InventoryManager {
  final StockApiService stockApiService;
  final LocationService locationService;
  final CouponRepository couponRepository;

  final Map<Product, int> _cart = {};

  InventoryManager({
    required this.stockApiService,
    required this.locationService,
    required this.couponRepository,
  });

  Map<Product, int> get cart => Map.unmodifiable(_cart);

  Future<void> addProduct(Product product, int quantity) async {
    if (quantity <= 0) {
      throw ArgumentError('La cantidad solicitada debe ser mayor a 0');
    }

    final currentQty = _cart[product] ?? 0;
    final totalRequested = currentQty + quantity;

    final availableStock = await stockApiService.getAvailableStock(product.id);

    if (totalRequested > availableStock) {
      throw InsufficientStockException(
        productId: product.id,
        available: availableStock,
        requested: totalRequested,
      );
    }

    _cart[product] = totalRequested;
  }

  Future<double> calculateTotal({String? couponCode}) async {
    double subtotal = 0.0;
    _cart.forEach((product, qty) {
      subtotal += product.price * qty;
    });

    // Descuento por cupón
    double discount = 0.0;
    if (couponCode != null && couponCode.trim().isNotEmpty) {
      final coupon = await couponRepository.findCoupon(couponCode.trim());
      if (coupon != null && coupon.isValid) {
        discount = subtotal * coupon.discountPercent;
      }
    }

    final discountedSubtotal = (subtotal - discount).clamp(0.0, double.infinity);

    // Impuesto regional dinámico
    final taxRate = await locationService.getRegionalTaxRate();
    final totalWithTax = discountedSubtotal * (1 + taxRate);

    return double.parse(totalWithTax.toStringAsFixed(2));
  }

  void clearCart() => _cart.clear();
}