import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final Cart cart;
  final bool showDismissible;

  const CartItem({required this.cart, this.showDismissible = true});

  @override
  Widget build(BuildContext context) {
    final listTile = ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(cart.product.imageUrl, scale: 3 / 2),
      ),
      title: Text(cart.product.title),
      subtitle: Text("Qty: ${cart.quantity} un"),
      trailing: Text('R\$ ${cart.price}'),
    );

    if (showDismissible) {
      return Dismissible(
        key: ValueKey(cart.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red.shade700,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (_) {
          return showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Remove confirmation'),
              content: const Text('Do you want to remove this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          Provider.of<CartProvider>(context, listen: false)
              .removeItem(cart.product);
        },
        child: listTile,
      );
    }

    return listTile;
  }
}
