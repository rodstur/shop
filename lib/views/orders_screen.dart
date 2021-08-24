import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_item.dart';
import 'package:shop/providers/orders_provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isloading = true;

  void toggleLoading() {
    setState(() {
      _isloading = !_isloading;
    });
  }

  @override
  void initState() {
    super.initState();

    final OrdersProvider ordersProvider = Provider.of(context, listen: false);
    ordersProvider.loadItemsFromServer(context).then((value) => toggleLoading());
  }

  @override
  Widget build(BuildContext context) {
    final OrdersProvider ordersProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: ordersProvider.items.map((e) => OrderItem(e)).toList(),
            ),
    );
  }
}
