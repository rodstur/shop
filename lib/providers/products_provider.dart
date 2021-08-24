import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:shop/providers/product_item_provider.dart';

class ProductsProvider with ChangeNotifier {
  final List<ProductItemProvider> _products = [];

  final _baseUrl = 'https://shop-74f46-default-rtdb.firebaseio.com/products';

  UnmodifiableListView<ProductItemProvider> get items => UnmodifiableListView(_products);

  List<ProductItemProvider> get showFavoriteItems =>
      items.where((prod) => prod.isFavorite).toList();

  int get length => _products.length;

  Future<bool> loadItemsFromServer() async {
    var futureResponse = Future.value(false);

    try {
      final response = await get(Uri.parse('$_baseUrl.json'));
      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (data != null) {
        _products.clear();

        data.forEach((id, product) {
          _products.add(ProductItemProvider(
            id: id,
            title: product['title'].toString(),
            description: product['description'].toString(),
            price: product['price'] as double,
            imageUrl: product['imageUrl'].toString(),
            isFavorite: product['isFavorite'] as bool,
          ));
        });

        futureResponse = Future.value(true);
        notifyListeners();
      }
    } catch (_) {}

    return futureResponse;
  }

  Future<bool> removeIem(ProductItemProvider product) async {
    Future<bool> futureResponse = Future.value(false);

    final indexWhere = _products.indexWhere((el) => el.id == product.id);

    if (indexWhere >= 0) {
      _products.remove(product);
      notifyListeners();

      final response = await delete(Uri.parse('$_baseUrl/${product.id}.js on'));

      if (response.statusCode >= 400) {
        _products.insert(indexWhere, product);
        notifyListeners();
      } else {
        futureResponse = Future.value(true);
      }
    }

    return futureResponse;
  }

  Future<bool> createOrUpdateProduct(ProductItemProvider product) async {
    if (product.id == null) {
      return _addItem(product);
    }

    return _updateItem(product);
  }

  Future<bool> _addItem(ProductItemProvider product) async {
    Future<bool> futureResponse = Future.value(false);

    try {
      final response = await post(
        Uri.parse('$_baseUrl.json'),
        body: json.encode(
          productToMap(product: product, unsetKeys: ['id']),
        ),
      );

      if (response.statusCode == 200) {
        _products.add(
          ProductItemProvider(
            id: json.decode(response.body)['name'].toString(),
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price,
            title: product.title,
          ),
        );

        futureResponse = Future.value(true);
        notifyListeners();
      }
    } catch (_) {}

    return futureResponse;
  }

  Future<bool> _updateItem(ProductItemProvider product) async {
    Future<bool> futureResponse = Future.value(false);

    final indexWhere = _products.indexWhere((el) => el.id == product.id);

    if (indexWhere >= 0) {
      try {
        var response = await get(Uri.parse('$_baseUrl/${product.id}.json'));
        final data = json.decode(response.body) as Map?;

        if (data != null) {
          response = await patch(
            Uri.parse('$_baseUrl/${product.id}.json'),
            body: json.encode(
              productToMap(product: product, unsetKeys: ['id', 'isFavorite']),
            ),
          );

          if (response.statusCode == 200) {
            _products[indexWhere] = product;

            futureResponse = Future.value(true);
            notifyListeners();
          }
        }
      } catch (_) {}
    }

    return futureResponse;
  }

  Map<String, Object?> productToMap(
      {required ProductItemProvider product, List<String> unsetKeys = const []}) {
    final data = {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };

    for (final key in unsetKeys) {
      data.remove(key);
    }

    return data;
  }
}
