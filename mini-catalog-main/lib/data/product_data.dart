import '../models/product.dart';

/// Ürün verilerini simüle eden JSON benzeri liste.
/// Gerçek bir uygulamada bu veriler bir API'den veya assets/json dosyasından gelir.
class ProductData {
  static final List<Map<String, dynamic>> _rawProducts = [
    {
      'id': 1,
      'name': 'Wireless Kulaklık',
      'description':
          'Yüksek kaliteli ses deneyimi sunan kablosuz Bluetooth kulaklık. '
              'Aktif gürültü engelleme özelliği ile dış sesleri minimuma indirir. '
              '30 saate kadar pil ömrü ve hızlı şarj desteği.',
      'price': 899.99,
      'imageUrl': 'assets/images/headphones.png',
      'category': 'Elektronik',
      'isFavorite': false,
    },
    {
      'id': 2,
      'name': 'Akıllı Saat',
      'description':
          'Fitness takibi, kalp ritmi ölçümü ve bildirim desteği olan akıllı saat. '
              'Su geçirmez tasarım, GPS ve 7 güne kadar pil ömrü. '
              '100\'den fazla egzersiz modu ile sağlığınızı takip edin.',
      'price': 2499.99,
      'imageUrl': 'assets/images/smartwatch.png',
      'category': 'Elektronik',
      'isFavorite': false,
    },
    {
      'id': 3,
      'name': 'Koşu Ayakkabısı',
      'description':
          'Hafif ve esnek yapısı ile konforlu koşu deneyimi. '
              'Nefes alabilen mesh üst kısım ve darbe emici taban teknolojisi. '
              'Hem yol hem de parkur koşusu için idealdir.',
      'price': 1299.99,
      'imageUrl': 'assets/images/shoes.png',
      'category': 'Spor',
      'isFavorite': false,
    },
    {
      'id': 4,
      'name': 'Yoga Matı',
      'description':
          'Kaymaz yüzey ve ekstra kalınlık ile maksimum konfor. '
              'Doğal kauçuk malzeme, çevre dostu ve dayanıklı. '
              'Taşıma kayışı ile birlikte gelir. 183x61cm boyutlarında.',
      'price': 349.99,
      'imageUrl': 'assets/images/yoga_mat.png',
      'category': 'Spor',
      'isFavorite': false,
    },
    {
      'id': 5,
      'name': 'Mekanik Klavye',
      'description':
          'Cherry MX Blue switch ile taktil ve sesli geri bildirim. '
              'RGB aydınlatma, programlanabilir makro tuşları ve dayanıklı yapı. '
              'Hem oyun hem de yazarlık için mükemmel bir deneyim.',
      'price': 1899.99,
      'imageUrl': 'assets/images/keyboard.png',
      'category': 'Elektronik',
      'isFavorite': false,
    },
    {
      'id': 6,
      'name': 'Sırt Çantası',
      'description':
          '15.6 inç laptop bölmesi, su geçirmez kumaş ve ergonomik tasarım. '
              'Çoklu cep düzeni ile eşyalarınızı düzenli taşıyın. '
              'Seyahat, okul ve iş için ideal.',
      'price': 599.99,
      'imageUrl': 'assets/images/backpack.png',
      'category': 'Aksesuar',
      'isFavorite': false,
    },
    {
      'id': 7,
      'name': 'Termos Bardak',
      'description':
          'Çift cidarlı vakum yalıtım teknolojisi ile içeceklerinizi '
              '12 saat sıcak veya 24 saat soğuk tutar. '
              'Paslanmaz çelik, BPA içermeyen kapak, 500ml kapasite.',
      'price': 199.99,
      'imageUrl': 'assets/images/thermos.png',
      'category': 'Ev & Yaşam',
      'isFavorite': false,
    },
    {
      'id': 8,
      'name': 'Masa Lambası',
      'description':
          'LED teknolojisi ile enerji tasarruflu, göz yormayan aydınlatma. '
              '5 farklı parlaklık seviyesi ve 3 renk modu. '
              'Dokunmatik kontrol ve USB şarj portu.',
      'price': 449.99,
      'imageUrl': 'assets/images/lamp.png',
      'category': 'Ev & Yaşam',
      'isFavorite': false,
    },
    {
      'id': 9,
      'name': 'Bluetooth Hoparlör',
      'description':
          'Taşınabilir, su geçirmez Bluetooth hoparlör. '
              '360 derece ses yayılımı ve güçlü bas performansı. '
              '20 saat pil ömrü, çift hoparlör eşleştirme desteği.',
      'price': 749.99,
      'imageUrl': 'assets/images/speaker.png',
      'category': 'Elektronik',
      'isFavorite': false,
    },
    {
      'id': 10,
      'name': 'Güneş Gözlüğü',
      'description':
          'UV400 koruma, polarize camlar ve hafif çerçeve. '
              'Hem sportif hem de günlük kullanıma uygun şık tasarım. '
              'Sert koruma kılıfı ve temizleme bezi ile birlikte.',
      'price': 399.99,
      'imageUrl': 'assets/images/sunglasses.png',
      'category': 'Aksesuar',
      'isFavorite': false,
    },
    {
      'id': 11,
      'name': 'Protein Tozu',
      'description':
          'Whey protein izolat, çikolata aromalı, 30 servis. '
              'Her serviste 25g protein, düşük yağ ve şeker içeriği. '
              'Antrenman sonrası kas onarımı ve gelişimi için idealdir.',
      'price': 549.99,
      'imageUrl': 'assets/images/protein.png',
      'category': 'Spor',
      'isFavorite': false,
    },
    {
      'id': 12,
      'name': 'Bitki Saksısı',
      'description':
          'Modern tasarımlı seramik saksı, alt tabak dahil. '
              'Drenaj delikli yapı ile bitki sağlığını korur. '
              'Orta boy, iç mekan bitkileri için uygun.',
      'price': 149.99,
      'imageUrl': 'assets/images/plant_pot.png',
      'category': 'Ev & Yaşam',
      'isFavorite': false,
    },
  ];

  /// Tüm ürünleri Product nesneleri olarak döndürür (fromJson kullanarak).
  static List<Product> getProducts() {
    return _rawProducts.map((json) => Product.fromJson(json)).toList();
  }

  /// Mevcut tüm kategorileri döndürür.
  static List<String> getCategories() {
    final categories =
        _rawProducts.map((json) => json['category'] as String).toSet().toList();
    categories.sort();
    return categories;
  }
}
