import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/filter_provider.dart';
import 'package:shop/utils/routes.dart';

import '../providers/cart_provider.dart';
import '../providers/product_item_provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductItemProvider product = Provider.of(context, listen: false);
    final CartProvider cart = Provider.of(context, listen: false);
    final filterFavorite = Provider.of<FilterProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.65),
          leading: IconButton(
            onPressed: () {
              product.toggleFavoriteNotifier();
              filterFavorite.updateFavorite();
            },
            icon: Consumer<ProductItemProvider>(
              builder: (ctx, prod, child) => Icon(
                prod.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: MaterialButton(
            minWidth: 0,
            splashColor: Theme.of(context).accentColor,
            shape: const CircleBorder(),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Product added!'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => cart.removeSingleItem(product),
                ),
              ));
              cart.addCart(product);
            },
            child: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetal,
            arguments: product,
          ),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
