class FallbackModels {
  static final List<Map<String, dynamic>> _models = [
    {
      'id': 'sony-a7iv',
      'categoryId': 'cat-dslr',
      'brand': 'Sony',
      'model': 'Alpha A7 IV',
      'basePrice': 115000,
      'image': 'assets/images/categories/dslr.png',
    },
    {
      'id': 'canon-r6ii',
      'categoryId': 'cat-dslr',
      'brand': 'Canon',
      'model': 'EOS R6 Mark II',
      'basePrice': 125000,
      'image': 'assets/images/categories/dslr.png',
    },
    {
      'id': 'iphone-15-pro',
      'categoryId': 'cat-smartphone',
      'brand': 'Apple',
      'model': 'iPhone 15 Pro',
      'basePrice': 55000,
      'image': 'assets/images/categories/smartphone.png',
    },
    {
      'id': 'macbook-pro-m3',
      'categoryId': 'cat-laptop',
      'brand': 'Apple',
      'model': 'MacBook Pro 14" M3',
      'basePrice': 95000,
      'image': 'assets/images/categories/laptop.png',
    },
    {
      'id': 'ipad-pro-m4',
      'categoryId': 'cat-tablet',
      'brand': 'Apple',
      'model': 'iPad Pro 11" M4',
      'basePrice': 62000,
      'image': 'assets/images/categories/tablet.png',
    },
  ];

  static List<Map<String, dynamic>> getModels({String? categoryId, String? search}) {
    var filtered = _models;
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      filtered = filtered.where((m) => m['categoryId'] == categoryId).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((m) =>
          (m['model'] as String).toLowerCase().contains(q) ||
          (m['brand'] as String).toLowerCase().contains(q)).toList();
    }
    return List<Map<String, dynamic>>.from(filtered);
  }
}
