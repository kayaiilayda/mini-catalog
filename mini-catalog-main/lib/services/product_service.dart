import '../data/product_data.dart';
import '../models/product.dart';

/// Ürün verilerini yöneten servis sınıfı.
/// Gerçek bir uygulamada burada API çağrıları veya veritabanı işlemleri olur.
class ProductService {
  List<Product> _products = [];

  ProductService() {
    _products = ProductData.getProducts();
  }

  /// Tüm ürünleri döndürür.
  List<Product> getAllProducts() {
    return List.unmodifiable(_products);
  }

  /// Belirli bir ID'ye sahip ürünü döndürür.
  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Kategoriye göre ürünleri filtreler.
  List<Product> getProductsByCategory(String category) {
    return _products
        .where((product) => product.category == category)
        .toList();
  }

  /// Ürün adına göre arama yapar (büyük/küçük harf duyarsız).
  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products
        .where((product) =>
            product.name.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Hem arama hem de kategori filtresi uygular.
  List<Product> filterProducts({String? query, String? category}) {
    var filtered = List<Product>.from(_products);

    if (category != null && category.isNotEmpty) {
      filtered =
          filtered.where((product) => product.category == category).toList();
    }

    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(lowerQuery) ||
              product.description.toLowerCase().contains(lowerQuery))
          .toList();
    }

    return filtered;
  }

  /// Favori durumunu değiştirir (toggle).
  void toggleFavorite(int productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.isFavorite = !product.isFavorite;
    }
  }

  /// Sadece favori ürünleri döndürür.
  List<Product> getFavoriteProducts() {
    return _products.where((product) => product.isFavorite).toList();
  }

  /// Tüm kategorileri döndürür.
  List<String> getCategories() {
    return ProductData.getCategories();
  }
}
