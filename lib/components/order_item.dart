import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_interpolation_to_compose_strings
    final subtitle = 'Order nº ${widget.order.id.hashCode} - ' +
        DateFormat('dd/MM/y').format(widget.order.date);

    return Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('R\$ ${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(subtitle),
              trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onTap: () => setState(() => _expanded = !_expanded),
            ),
            if (_expanded)
              Column(
                children: <Widget>[
                  Container(
                    height: widget.order.products.length * 85,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: widget.order.products.length,
                      itemBuilder: (BuildContext _, int i) {
                        return CartItem(
                          cart: widget.order.products[i],
                          showDismissible: false,
                        );
                      },
                    ),
                  ),
                ],
              )
          ],
        ));
  }
}
