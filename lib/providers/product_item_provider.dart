import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ProductItemProvider with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  ProductItemProvider({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteNotifier() async {
    final baseUrl = 'https://shop-74f46-default-rtdb.firebaseio.com/products/$id.json';

    _toggleFavorite();

    try {
      final response = await patch(
        Uri.parse(baseUrl),
        body: jsonEncode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (e) {
      _toggleFavorite();
    }
  }
}
