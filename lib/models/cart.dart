import 'dart:math';

import 'package:shop/providers/product_item_provider.dart';

class Cart {
  final String id;
  final double price;
  final int quantity;
  final ProductItemProvider product;

  const Cart({
    required this.id,
    required this.product,
    required this.price,
    required this.quantity,
  });

  Cart.fromProduct(this.product, {String? id, double? price, int? quantity})
      : id = id ?? Random().nextDouble().toString(),
        price = price ?? product.price,
        quantity = quantity ?? 1;
}
