import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../helpers/category_helpers.dart';

/// Favoriler sayfası: Favori ürünleri ListView.builder ile listeler.
class FavoritesScreen extends StatefulWidget {
  final ProductService productService;
  final CartService cartService;

  const FavoritesScreen({
    super.key,
    required this.productService,
    required this.cartService,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = widget.productService.getFavoriteProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorilerim',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return _FavoriteItemCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: product.id,
                    ).then((_) => setState(() {}));
                  },
                  onRemoveFavorite: () {
                    setState(() {
                      widget.productService.toggleFavorite(product.id);
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${product.name} favorilerden çıkarıldı.'),
                        action: SnackBarAction(
                          label: 'GERİ AL',
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              widget.productService
                                  .toggleFavorite(product.id);
                            });
                          },
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  onAddToCart: () {
                    widget.cartService.addToCart(product);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} sepete eklendi!'),
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
                  },
                );
              },
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: Colors.red.shade200,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz favori ürününüz yok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Beğendiğiniz ürünlerin kalp ikonuna tıklayarak\nfavorilerinize ekleyebilirsiniz.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Alışverişe Başla'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemoveFavorite;
  final VoidCallback onAddToCart;

  const _FavoriteItemCard({
    required this.product,
    required this.onTap,
    required this.onRemoveFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Ürün görseli
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            CategoryHelpers.getIcon(product.category),
                            size: 32,
                            color:
                                CategoryHelpers.getColor(product.category),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Ürün bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: CategoryHelpers.getColor(product.category),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${product.price.toStringAsFixed(2)} \u20BA',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Aksiyonlar
              Column(
                children: [
                  // Sepete ekle
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      tooltip: 'Sepete ekle',
                      onPressed: onAddToCart,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Favoriden çıkar
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                      tooltip: 'Favorilerden çıkar',
                      onPressed: onRemoveFavorite,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
