import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_item_provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductManagerItem extends StatelessWidget {
  final ProductItemProvider product;

  const ProductManagerItem(this.product);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(product.id),
      onDismissed: (_) => productsProvider.removeIem(product),
      direction: DismissDirection.endToStart,
      movementDuration: const Duration(milliseconds: 100),
      background: Container(
        color: Theme.of(context).errorColor,
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (_) => _removeItemDialog(context),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
          backgroundColor: Colors.transparent,
        ),
        title: Text(product.title),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.productForm, arguments: product);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                  onPressed: () => _removeItemDialog(context).then((value) {
                        if (value as bool) productsProvider.removeIem(product);
                      }),
                  icon:
                      Icon(Icons.delete, color: Theme.of(context).errorColor)),
            ],
          ),
        ),
      ),
    );
  }

  Future<T?> _removeItemDialog<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Confirmation'),
        content: const Text('Do you want remove?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
