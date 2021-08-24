import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';

import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  double getComponentHeight(BuildContext context, String component) {
    final height = {
      Orientation.portrait: {'listview': 0.92, 'bottombar': 0.08},
      Orientation.landscape: {'listview': 0.80, 'bottombar': 0.2},
    };

    return height[MediaQuery.of(context).orientation]![component]!;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    final PreferredSizeWidget appBar = AppBar(
      title: const Text('Cart Items'),
      actions: [
        IconButton(
          onPressed: () => cartProvider.clearCart(),
          icon: const Icon(Icons.delete),
          tooltip: 'Clear Cart',
        )
      ],
    );

    final carItems = cartProvider.items.values;

    final avaliableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: carItems.isEmpty
          ? const Center(child: Text('No cart items'))
          : SizedBox(
              height: avaliableHeight,
              child: LayoutBuilder(
                builder: (_, constraints) => Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * getComponentHeight(context, 'listview'),
                      child: ListView.separated(
                        itemBuilder: (_, index) => CartItem(cart: carItems.elementAt(index)),
                        separatorBuilder: (_, __) => const Divider(),
                        itemCount: cartProvider.lenght,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * getComponentHeight(context, 'bottombar'),
                      child: Card(
                        elevation: 1,
                        margin: const EdgeInsets.all(0),
                        //margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                Provider.of<OrdersProvider>(context, listen: false)
                                    .addOrder(carItems.toList());
                                cartProvider.clearCart();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'BUY',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text('Total', style: TextStyle(fontSize: 17)),
                            const SizedBox(width: 10),
                            Chip(
                              label: Text(
                                'R\$ ${cartProvider.sumItemsValues.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
