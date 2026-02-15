import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../helpers/category_helpers.dart';

/// Sepet sayfası: Sepetteki ürünleri listeler, adet düzenleme, silme
/// ve toplam tutar gösterimi sağlar.
class CartScreen extends StatefulWidget {
  final CartService cartService;

  const CartScreen({super.key, required this.cartService});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          ListenableBuilder(
            listenable: widget.cartService,
            builder: (context, _) {
              if (widget.cartService.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Sepeti temizle',
                onPressed: () => _showClearCartDialog(context),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.cartService,
        builder: (context, _) {
          if (widget.cartService.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildCartContent(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.blue.shade200,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sepetiniz boş',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Beğendiğiniz ürünleri sepete ekleyerek\nalışverişe başlayabilirsiniz.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Alışverişe Başla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context) {
    final items = widget.cartService.items;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Ürün listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartItem = items[index];
              return _CartItemCard(
                cartItem: cartItem,
                onIncrement: () {
                  widget.cartService
                      .incrementQuantity(cartItem.product.id);
                },
                onDecrement: () {
                  widget.cartService
                      .decrementQuantity(cartItem.product.id);
                },
                onRemove: () {
                  final removedItem = cartItem;
                  widget.cartService.removeFromCart(cartItem.product.id);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${removedItem.product.name} sepetten çıkarıldı.'),
                      action: SnackBarAction(
                        label: 'GERİ AL',
                        textColor: Colors.white,
                        onPressed: () {
                          for (int i = 0;
                              i < removedItem.quantity;
                              i++) {
                            widget.cartService
                                .addToCart(removedItem.product);
                          }
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: cartItem.product.id,
                  );
                },
              );
            },
          ),
        ),

        // Alt kısım: Toplam ve sipariş butonu
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Özet satırları
                  _buildSummaryRow(
                    'Ürün sayısı',
                    '${widget.cartService.totalItemCount} adet',
                  ),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    'Kargo',
                    'Ücretsiz',
                    valueColor: Colors.green.shade600,
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Toplam',
                    '${widget.cartService.totalPrice.toStringAsFixed(2)} \u20BA',
                    isBold: true,
                    valueColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Siparişi Tamamla butonu
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _showCheckoutDialog(context),
                      icon: const Icon(Icons.payment_rounded),
                      label: const Text(
                        'Siparişi Tamamla',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 17 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? Colors.grey.shade800 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sepeti Temizle'),
        content:
            const Text('Sepetinizdeki tüm ürünler kaldırılacaktır. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              widget.cartService.clearCart();
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 48,
            color: Colors.green.shade400,
          ),
        ),
        title: const Text('Sipariş Onayı'),
        content: Text(
          'Toplam ${widget.cartService.totalPrice.toStringAsFixed(2)} \u20BA tutarındaki '
          'siparişiniz alındı!\n\n'
          'Bu bir demo uygulamadır. Gerçek bir ödeme işlemi yapılmamıştır.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.cartService.clearCart();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _CartItemCard({
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
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
              // Bilgiler ve kontroller
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // İsim ve silme butonu
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            onPressed: onRemove,
                            padding: EdgeInsets.zero,
                            tooltip: 'Kaldır',
                          ),
                        ),
                      ],
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
                    const SizedBox(height: 8),
                    // Fiyat ve adet kontrolleri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${cartItem.totalPrice.toStringAsFixed(2)} \u20BA',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        // Adet kontrolleri
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _QuantityButton(
                                icon: Icons.remove,
                                onTap: onDecrement,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _QuantityButton(
                                icon: Icons.add,
                                onTap: onIncrement,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}
