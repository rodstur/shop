import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';
import 'package:shop/providers/products_provider.dart';

class OrdersProvider extends ChangeNotifier {
  final _baseUrl = 'https://shop-74f46-default-rtdb.firebaseio.com/orders.json';

  final List<Order> _orders = [];

  List<Order> get items => UnmodifiableListView(_orders);

  int get length => _orders.length;

  Future<bool> loadItemsFromServer(BuildContext context) async {
    Future<bool> futureResponse = Future.value(false);

    final response = await get(Uri.parse(_baseUrl));
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data != null) {
      _orders.clear();

      data.forEach((key, value) {
        _orders.add(
          Order(
            id: key,
            amount: value['amount'] as double,
            products: _createCartList(value['products'], context),
            date: DateTime.parse(value['date'].toString()),
          ),
        );
      });

      notifyListeners();
      futureResponse = Future.value(true);
    }

    return futureResponse;
  }

  Future<bool> addOrder(List<Cart> products) async {
    Future<bool> futureResponse = Future.value(false);

    final amount = products.fold<double>(0, (t, n) => t + n.price * n.quantity);
    final date = DateTime.now();

    final response = await post(
      Uri.parse(_baseUrl),
      body: json.encode({
        'amount': amount,
        'date': date.toIso8601String(),
        'products': products
            .map((e) => {
                  'id': e.id,
                  'price': e.price,
                  'quantity': e.quantity,
                  'product': e.product.id,
                })
            .toList()
      }),
    );

    if (response.statusCode == 200) {
      _orders.add(
        Order(
          id: json.decode(response.body)['name'].toString(),
          amount: amount,
          products: products,
          date: date,
        ),
      );

      notifyListeners();
      futureResponse = Future.value(true);
    }

    return futureResponse;
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  List<Cart> _createCartList(dynamic cartItems, BuildContext context) {
    final List<Cart> cartList = [];

    for (final item in cartItems) {
      final product = Provider.of<ProductsProvider>(context, listen: false)
          .items
          .singleWhere((el) => el.id == item['product'].toString());

      cartList.add(Cart(
        id: item['id'].toString(),
        product: product,
        price: item['price'] as double,
        quantity: item['quantity'] as int,
      ));
    }

    return cartList;
  }
}
