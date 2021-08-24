import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/cart.dart';
import 'product_item_provider.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items => UnmodifiableMapView(_items);

  int get lenght => _items.length;

  double get sumItemsValues {
    return items.values
        .map((cart) => cart.price * cart.quantity)
        .reduce((sum, next) => sum + next);
  }

  void addCart(ProductItemProvider product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id!,
        (item) => Cart.fromProduct(product, quantity: item.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        product.id!,
        () => Cart.fromProduct(product),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(ProductItemProvider product) {
    if (items.containsKey(product.id)) {
      if (_items[product.id]!.quantity == 1) {
        _items.remove(product.id);
      } else {
        _items.update(
          product.id!,
          (item) => Cart.fromProduct(product, quantity: item.quantity - 1),
        );
      }

      notifyListeners();
    }
  }

  void removeItem(ProductItemProvider product) {
    if (items.containsKey(product.id)) {
      _items.remove(product.id);

      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
