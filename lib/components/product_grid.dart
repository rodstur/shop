import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/filter_provider.dart';

import '../providers/product_item_provider.dart';
import '../providers/products_provider.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final bool filterFavorites;

  const ProductGrid({this.filterFavorites = false});

  @override
  Widget build(BuildContext context) {
    final filterFavorites = Provider.of<FilterProvider>(context).favorite;

    final List<ProductItemProvider> products = filterFavorites
        ? Provider.of<ProductsProvider>(context).showFavoriteItems
        : Provider.of<ProductsProvider>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductGridItem(),
      ),
    );
  }
}
