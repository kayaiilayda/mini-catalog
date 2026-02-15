import 'package:flutter/material.dart';
import '../services/cart_service.dart';

/// AppBar'da sepet ikonuyla birlikte ürün sayısını gösteren badge widget'ı.
class CartBadge extends StatelessWidget {
  final CartService cartService;
  final VoidCallback onTap;

  const CartBadge({
    super.key,
    required this.cartService,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cartService,
      builder: (context, _) {
        final count = cartService.totalItemCount;
        return IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart_outlined),
              if (count > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          tooltip: 'Sepetim ($count)',
          onPressed: onTap,
        );
      },
    );
  }
}
