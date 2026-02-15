import 'package:flutter/material.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MiniCatalogApp());
}

/// Mini Catalog uygulamasının kök widget'ı.
/// Named routes ile sayfa yönlendirmesi yapılır.
/// ProductService ve CartService uygulama genelinde paylaşılır.
class MiniCatalogApp extends StatefulWidget {
  const MiniCatalogApp({super.key});

  @override
  State<MiniCatalogApp> createState() => _MiniCatalogAppState();
}

class _MiniCatalogAppState extends State<MiniCatalogApp> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  @override
  void dispose() {
    _cartService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              productService: _productService,
              cartService: _cartService,
            ),
        '/detail': (context) => ProductDetailScreen(
              productService: _productService,
              cartService: _cartService,
            ),
        '/favorites': (context) => FavoritesScreen(
              productService: _productService,
              cartService: _cartService,
            ),
        '/cart': (context) => CartScreen(
              cartService: _cartService,
            ),
      },
    );
  }

  ThemeData _buildTheme() {
    const primaryColor = Color(0xFF1565C0);
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
