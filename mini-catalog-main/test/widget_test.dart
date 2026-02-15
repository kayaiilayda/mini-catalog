import 'package:flutter_test/flutter_test.dart';
import 'package:mini_catalog/models/product.dart';
import 'package:mini_catalog/models/cart_item.dart';
import 'package:mini_catalog/services/product_service.dart';
import 'package:mini_catalog/services/cart_service.dart';
import 'package:mini_catalog/data/product_data.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson creates correct Product', () {
      final json = {
        'id': 1,
        'name': 'Test Ürün',
        'description': 'Test açıklama',
        'price': 99.99,
        'imageUrl': 'assets/images/test.png',
        'category': 'Test',
        'isFavorite': false,
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'Test Ürün');
      expect(product.description, 'Test açıklama');
      expect(product.price, 99.99);
      expect(product.imageUrl, 'assets/images/test.png');
      expect(product.category, 'Test');
      expect(product.isFavorite, false);
    });

    test('Product.toJson creates correct Map', () {
      final product = Product(
        id: 1,
        name: 'Test Ürün',
        description: 'Test açıklama',
        price: 99.99,
        imageUrl: 'assets/images/test.png',
        category: 'Test',
        isFavorite: true,
      );

      final json = product.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Ürün');
      expect(json['price'], 99.99);
      expect(json['isFavorite'], true);
    });

    test('Product.fromJson handles missing isFavorite', () {
      final json = {
        'id': 1,
        'name': 'Test',
        'description': 'Desc',
        'price': 10.0,
        'imageUrl': 'img.png',
        'category': 'Cat',
      };

      final product = Product.fromJson(json);
      expect(product.isFavorite, false);
    });
  });

  group('CartItem Model Tests', () {
    test('CartItem calculates totalPrice correctly', () {
      final product = Product(
        id: 1,
        name: 'Test',
        description: 'Desc',
        price: 100.0,
        imageUrl: 'img.png',
        category: 'Cat',
      );

      final cartItem = CartItem(product: product, quantity: 3);
      expect(cartItem.totalPrice, 300.0);
    });

    test('CartItem.fromJson and toJson roundtrip', () {
      final product = Product(
        id: 1,
        name: 'Test',
        description: 'Desc',
        price: 50.0,
        imageUrl: 'img.png',
        category: 'Cat',
      );

      final original = CartItem(product: product, quantity: 2);
      final json = original.toJson();
      final restored = CartItem.fromJson(json);

      expect(restored.product.id, original.product.id);
      expect(restored.quantity, original.quantity);
      expect(restored.totalPrice, original.totalPrice);
    });

    test('CartItem default quantity is 1', () {
      final product = Product(
        id: 1,
        name: 'Test',
        description: 'Desc',
        price: 100.0,
        imageUrl: 'img.png',
        category: 'Cat',
      );

      final cartItem = CartItem(product: product);
      expect(cartItem.quantity, 1);
    });
  });

  group('ProductService Tests', () {
    late ProductService service;

    setUp(() {
      service = ProductService();
    });

    test('getAllProducts returns all products', () {
      final products = service.getAllProducts();
      expect(products.isNotEmpty, true);
      expect(products.length, 12);
    });

    test('getProductById returns correct product', () {
      final product = service.getProductById(1);
      expect(product, isNotNull);
      expect(product!.id, 1);
    });

    test('getProductById returns null for invalid id', () {
      final product = service.getProductById(999);
      expect(product, isNull);
    });

    test('getProductsByCategory filters correctly', () {
      final products = service.getProductsByCategory('Elektronik');
      expect(products.isNotEmpty, true);
      for (final product in products) {
        expect(product.category, 'Elektronik');
      }
    });

    test('searchProducts finds matching products', () {
      final products = service.searchProducts('kulaklık');
      expect(products.isNotEmpty, true);
    });

    test('searchProducts is case insensitive', () {
      final lower = service.searchProducts('kulaklık');
      final upper = service.searchProducts('KULAKLIK');
      expect(lower.length, upper.length);
    });

    test('toggleFavorite changes favorite status', () {
      final product = service.getProductById(1)!;
      expect(product.isFavorite, false);

      service.toggleFavorite(1);
      expect(product.isFavorite, true);

      service.toggleFavorite(1);
      expect(product.isFavorite, false);
    });

    test('getFavoriteProducts returns only favorites', () {
      service.toggleFavorite(1);
      service.toggleFavorite(3);

      final favorites = service.getFavoriteProducts();
      expect(favorites.length, 2);
      for (final product in favorites) {
        expect(product.isFavorite, true);
      }
    });

    test('filterProducts with query and category', () {
      final products = service.filterProducts(
        query: 'saat',
        category: 'Elektronik',
      );
      expect(products.isNotEmpty, true);
      for (final product in products) {
        expect(product.category, 'Elektronik');
      }
    });

    test('filterProducts with empty query returns category filtered', () {
      final products = service.filterProducts(
        query: '',
        category: 'Spor',
      );
      for (final product in products) {
        expect(product.category, 'Spor');
      }
    });

    test('getCategories returns all unique categories', () {
      final categories = service.getCategories();
      expect(categories.isNotEmpty, true);
      expect(categories.contains('Elektronik'), true);
      expect(categories.contains('Spor'), true);
      expect(categories.contains('Aksesuar'), true);
      expect(categories.contains('Ev & Yaşam'), true);
    });
  });

  group('CartService Tests', () {
    late CartService cartService;
    late Product testProduct;
    late Product testProduct2;

    setUp(() {
      cartService = CartService();
      testProduct = Product(
        id: 1,
        name: 'Test Ürün 1',
        description: 'Açıklama 1',
        price: 100.0,
        imageUrl: 'img1.png',
        category: 'Test',
      );
      testProduct2 = Product(
        id: 2,
        name: 'Test Ürün 2',
        description: 'Açıklama 2',
        price: 200.0,
        imageUrl: 'img2.png',
        category: 'Test',
      );
    });

    test('cart starts empty', () {
      expect(cartService.isEmpty, true);
      expect(cartService.totalItemCount, 0);
      expect(cartService.uniqueItemCount, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('addToCart adds product', () {
      cartService.addToCart(testProduct);
      expect(cartService.isEmpty, false);
      expect(cartService.totalItemCount, 1);
      expect(cartService.uniqueItemCount, 1);
    });

    test('addToCart same product increments quantity', () {
      cartService.addToCart(testProduct);
      cartService.addToCart(testProduct);
      expect(cartService.totalItemCount, 2);
      expect(cartService.uniqueItemCount, 1);
      expect(cartService.getQuantity(testProduct.id), 2);
    });

    test('addToCart different products', () {
      cartService.addToCart(testProduct);
      cartService.addToCart(testProduct2);
      expect(cartService.uniqueItemCount, 2);
      expect(cartService.totalItemCount, 2);
    });

    test('totalPrice calculates correctly', () {
      cartService.addToCart(testProduct); // 100
      cartService.addToCart(testProduct); // 100 (qty: 2)
      cartService.addToCart(testProduct2); // 200
      expect(cartService.totalPrice, 400.0);
    });

    test('removeFromCart removes product', () {
      cartService.addToCart(testProduct);
      cartService.addToCart(testProduct);
      cartService.removeFromCart(testProduct.id);
      expect(cartService.isEmpty, true);
    });

    test('incrementQuantity increases count', () {
      cartService.addToCart(testProduct);
      cartService.incrementQuantity(testProduct.id);
      expect(cartService.getQuantity(testProduct.id), 2);
    });

    test('decrementQuantity decreases count', () {
      cartService.addToCart(testProduct);
      cartService.addToCart(testProduct);
      cartService.decrementQuantity(testProduct.id);
      expect(cartService.getQuantity(testProduct.id), 1);
    });

    test('decrementQuantity removes item when quantity reaches 0', () {
      cartService.addToCart(testProduct);
      cartService.decrementQuantity(testProduct.id);
      expect(cartService.isEmpty, true);
    });

    test('isInCart returns correct status', () {
      expect(cartService.isInCart(testProduct.id), false);
      cartService.addToCart(testProduct);
      expect(cartService.isInCart(testProduct.id), true);
    });

    test('clearCart removes all items', () {
      cartService.addToCart(testProduct);
      cartService.addToCart(testProduct2);
      cartService.clearCart();
      expect(cartService.isEmpty, true);
      expect(cartService.totalItemCount, 0);
    });

    test('getQuantity returns 0 for non-existing product', () {
      expect(cartService.getQuantity(999), 0);
    });
  });

  group('ProductData Tests', () {
    test('getProducts returns list of Product objects', () {
      final products = ProductData.getProducts();
      expect(products, isA<List<Product>>());
      expect(products.isNotEmpty, true);
    });

    test('getCategories returns unique sorted categories', () {
      final categories = ProductData.getCategories();
      expect(categories, isA<List<String>>());

      for (int i = 0; i < categories.length - 1; i++) {
        expect(categories[i].compareTo(categories[i + 1]) <= 0, true);
      }
    });

    test('all products have valid data', () {
      final products = ProductData.getProducts();
      for (final product in products) {
        expect(product.id, greaterThan(0));
        expect(product.name.isNotEmpty, true);
        expect(product.description.isNotEmpty, true);
        expect(product.price, greaterThan(0));
        expect(product.imageUrl.isNotEmpty, true);
        expect(product.category.isNotEmpty, true);
      }
    });
  });
}
