import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Sepet işlemlerini yöneten servis.
/// ChangeNotifier ile state değişikliklerini dinleyicilere bildirir.
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Sepetteki tüm ürünler.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Sepetteki toplam ürün sayısı (adetler dahil).
  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Sepetteki benzersiz ürün sayısı.
  int get uniqueItemCount => _items.length;

  /// Sepet toplam tutarı.
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Sepetin boş olup olmadığı.
  bool get isEmpty => _items.isEmpty;

  /// Belirli bir ürünün sepette olup olmadığını kontrol eder.
  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Sepetteki bir ürünün adetini döndürür.
  int getQuantity(int productId) {
    try {
      return _items
          .firstWhere((item) => item.product.id == productId)
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  /// Sepete ürün ekler. Zaten varsa adedi artırır.
  void addToCart(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// Sepetten ürün çıkarır (tamamen).
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Ürün adetini artırır.
  void incrementQuantity(int productId) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    item.quantity++;
    notifyListeners();
  }

  /// Ürün adetini azaltır. 1'den az olursa sepetten çıkarır.
  void decrementQuantity(int productId) {
    final index =
        _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Sepeti tamamen temizler.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
