import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/cart_badge.dart';

/// Ana sayfa: Ürün listesi, arama çubuğu, kategori filtresi ve sepet erişimi.
/// GridView.builder ile ürün kartlarını gösterir.
class HomeScreen extends StatefulWidget {
  final ProductService productService;
  final CartService cartService;

  const HomeScreen({
    super.key,
    required this.productService,
    required this.cartService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String _searchQuery = '';

  List<Product> get _filteredProducts {
    return widget.productService.filterProducts(
      query: _searchQuery,
      category: _selectedCategory,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSearchClear() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onProductTap(Product product) {
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: product.id,
    ).then((_) {
      // Detay sayfasından dönünce favori değişikliklerini yansıt
      setState(() {});
    });
  }

  void _onFavoriteToggle(Product product) {
    setState(() {
      widget.productService.toggleFavorite(product.id);
    });
  }

  void _onAddToCart(Product product) {
    widget.cartService.addToCart(product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${product.name} sepete eklendi!'),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'SEPETE GIT',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    final categories = widget.productService.getCategories();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
            const SizedBox(width: 8),
            const Text(
              'Mini Katalog',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            tooltip: 'Favorilerim',
            onPressed: () {
              Navigator.pushNamed(context, '/favorites').then((_) {
                setState(() {});
              });
            },
          ),
          CartBadge(
            cartService: widget.cartService,
            onTap: () {
              Navigator.pushNamed(context, '/cart').then((_) {
                setState(() {});
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _onSearchClear,
            ),
          ),

          // Kategori filtresi (Yatay ListView.builder)
          CategoryFilter(
            categories: categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),

          // Sonuç bilgisi
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  '${products.length} ürün bulundu',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Ürün GridView
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _onProductTap(product),
                        onFavoriteToggle: () => _onFavoriteToggle(product),
                        onAddToCart: () => _onAddToCart(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 56,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Farklı bir arama terimi veya kategori deneyin.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
