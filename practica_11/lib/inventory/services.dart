import 'models.dart';

abstract class StockApiService {
  Future<int> getAvailableStock(String productId);
}

abstract class LocationService {
  Future<double> getRegionalTaxRate(); // Retorna tasa regional (ej. 0.18 para IGV 18%)
}

abstract class CouponRepository {
  Future<Coupon?> findCoupon(String code);
}