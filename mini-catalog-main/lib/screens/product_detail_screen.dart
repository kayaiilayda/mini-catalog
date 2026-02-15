import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../helpers/category_helpers.dart';

/// Ürün detay sayfası: Route Arguments ile ürün ID'si alınır,
/// tüm bilgiler gösterilir, sepete ekleme ve favori toggle yapılır.
class ProductDetailScreen extends StatefulWidget {
  final ProductService productService;
  final CartService cartService;

  const ProductDetailScreen({
    super.key,
    required this.productService,
    required this.cartService,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;
    final product = widget.productService.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: const Center(child: Text('Ürün bulunamadı.')),
      );
    }

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible AppBar with product image
          SliverAppBar(
            expandedHeight: screenWidth * 0.85,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.surface,
            leading: _buildBackButton(context),
            actions: [
              _buildFavoriteAppBarButton(product),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: 'product_image_${product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.shade50,
                        Colors.grey.shade200,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 80, 40, 20),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            CategoryHelpers.getIcon(product.category),
                            size: 100,
                            color: CategoryHelpers.getColor(product.category),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori + ID
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: CategoryHelpers.getColor(product.category),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CategoryHelpers.getIcon(product.category),
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'SKU: #${product.id.toString().padLeft(4, '0')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Ürün adı
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Fiyat ve sepet durumu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} \u20BA',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ListenableBuilder(
                          listenable: widget.cartService,
                          builder: (context, _) {
                            final qty =
                                widget.cartService.getQuantity(product.id);
                            if (qty > 0) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.green.shade200),
                                ),
                                child: Text(
                                  'Sepette: $qty adet',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Açıklama
                    Text(
                      'Ürün Açıklaması',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ürün özellikleri
                    _buildInfoCard(context, product),

                    const SizedBox(height: 28),

                    // Butonlar
                    _buildActionButtons(context, product),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white.withOpacity(0.9),
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.arrow_back, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteAppBarButton(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white.withOpacity(0.9),
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            setState(() {
              widget.productService.toggleFavorite(product.id);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red.shade400 : Colors.grey,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ürün Bilgileri',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.tag_rounded, 'Ürün ID', '#${product.id}'),
          _divider(),
          _infoRow(Icons.category_rounded, 'Kategori', product.category),
          _divider(),
          _infoRow(Icons.monetization_on_rounded, 'Fiyat',
              '${product.price.toStringAsFixed(2)} \u20BA'),
          _divider(),
          _infoRow(
            Icons.favorite_rounded,
            'Favori',
            product.isFavorite ? 'Evet' : 'Hayır',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 16, color: Colors.grey.shade200);
  }

  Widget _buildActionButtons(BuildContext context, Product product) {
    return Column(
      children: [
        // Sepete Ekle butonu
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              widget.cartService.addToCart(product);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('${product.name} sepete eklendi!')),
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
              setState(() {});
            },
            icon: const Icon(Icons.shopping_cart_rounded),
            label: const Text(
              'Sepete Ekle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Favori butonu
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                widget.productService.toggleFavorite(product.id);
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product.isFavorite
                              ? '${product.name} favorilere eklendi!'
                              : '${product.name} favorilerden çıkarıldı.',
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red.shade400 : null,
            ),
            label: Text(
              product.isFavorite ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
