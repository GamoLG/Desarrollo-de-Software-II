import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practica_11/inventory/exceptions.dart';
import 'package:practica_11/inventory/inventory_manager.dart';
import 'package:practica_11/inventory/models.dart';
import 'package:practica_11/inventory/services.dart';

// Mocks generados con Mocktail
class MockStockApiService extends Mock implements StockApiService {}
class MockLocationService extends Mock implements LocationService {}
class MockCouponRepository extends Mock implements CouponRepository {}

void main() {
  late InventoryManager inventoryManager;
  late MockStockApiService mockStockApi;
  late MockLocationService mockLocationService;
  late MockCouponRepository mockCouponRepository;

  const testProduct = Product(id: 'prod_001', name: 'Laptop Gaming', price: 1000.0);

  setUp(() {
    mockStockApi = MockStockApiService();
    mockLocationService = MockLocationService();
    mockCouponRepository = MockCouponRepository();

    inventoryManager = InventoryManager(
      stockApiService: mockStockApi,
      locationService: mockLocationService,
      couponRepository: mockCouponRepository,
    );
  });

  group('InventoryManager - addProduct:', () {
    test('Debe agregar el producto y acumular stock si hay disponibilidad suficiente', () async {
      // Arrange
      when(() => mockStockApi.getAvailableStock('prod_001'))
          .thenAnswer((_) async => 10);

      // Act
      await inventoryManager.addProduct(testProduct, 2);

      // Assert
      expect(inventoryManager.cart[testProduct], equals(2));
      verify(() => mockStockApi.getAvailableStock('prod_001')).called(1);

      // Segunda agregación acumulativa
      await inventoryManager.addProduct(testProduct, 3);
      expect(inventoryManager.cart[testProduct], equals(5));
    });

    test('Debe lanzar InsufficientStockException si la cantidad excede existencias', () async {
      // Arrange
      when(() => mockStockApi.getAvailableStock('prod_001'))
          .thenAnswer((_) async => 3);

      // Act & Assert
      expect(
            () => inventoryManager.addProduct(testProduct, 5),
        throwsA(isA<InsufficientStockException>()
            .having((e) => e.productId, 'productId', 'prod_001')
            .having((e) => e.available, 'available', 3)
            .having((e) => e.requested, 'requested', 5)),
      );
    });

    test('Debe lanzar ArgumentError si se ingresa una cantidad menor o igual a cero', () async {
      expect(() => inventoryManager.addProduct(testProduct, 0), throwsArgumentError);
      expect(() => inventoryManager.addProduct(testProduct, -3), throwsArgumentError);
    });
  });

  group('InventoryManager - calculateTotal:', () {
    setUp(() {
      when(() => mockStockApi.getAvailableStock(any())).thenAnswer((_) async => 50);
    });

    test('Calcula el total aplicando la tasa impositiva regional sin cupones', () async {
      await inventoryManager.addProduct(testProduct, 1); // Subtotal = 1000.0
      when(() => mockLocationService.getRegionalTaxRate()).thenAnswer((_) async => 0.18);

      final total = await inventoryManager.calculateTotal();

      // 1000 * 1.18 = 1180.0
      expect(total, equals(1180.0));
      verify(() => mockLocationService.getRegionalTaxRate()).called(1);
    });

    test('Aplica descuento cuando el cupón es válido', () async {
      await inventoryManager.addProduct(testProduct, 1); // Subtotal = 1000.0
      when(() => mockLocationService.getRegionalTaxRate()).thenAnswer((_) async => 0.18);
      when(() => mockCouponRepository.findCoupon('PROMO20')).thenAnswer(
            (_) async => Coupon(
          code: 'PROMO20',
          discountPercent: 0.20,
          expirationDate: DateTime.now().add(const Duration(days: 5)),
        ),
      );

      final total = await inventoryManager.calculateTotal(couponCode: 'PROMO20');

      // Subtotal = 1000, Descuento 20% = 800, Total = 800 * 1.18 = 944.0
      expect(total, equals(944.0));
      verify(() => mockCouponRepository.findCoupon('PROMO20')).called(1);
    });

    test('Ignora cupón vencido y aplica precio regular con impuesto', () async {
      await inventoryManager.addProduct(testProduct, 1);
      when(() => mockLocationService.getRegionalTaxRate()).thenAnswer((_) async => 0.10);
      when(() => mockCouponRepository.findCoupon('VENCIDO')).thenAnswer(
            (_) async => Coupon(
          code: 'VENCIDO',
          discountPercent: 0.50,
          expirationDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      final total = await inventoryManager.calculateTotal(couponCode: 'VENCIDO');

      // 1000 * 1.10 = 1100.0
      expect(total, equals(1100.0));
    });

    test('Maneja correctamente cupones inexistentes (null)', () async {
      await inventoryManager.addProduct(testProduct, 1);
      when(() => mockLocationService.getRegionalTaxRate()).thenAnswer((_) async => 0.0);
      when(() => mockCouponRepository.findCoupon('INVALIDO')).thenAnswer((_) async => null);

      final total = await inventoryManager.calculateTotal(couponCode: 'INVALIDO');
      expect(total, equals(1000.0));
    });
  });
}