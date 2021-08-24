import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/filter_provider.dart';
import 'package:shop/providers/products_provider.dart';

import '../components/badge.dart';
import '../components/product_grid.dart';
import '../utils/routes.dart';

enum FilterOptions { favorite, all }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() {
    return _ProductsOverviewScreenState();
  }
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<ProductsProvider>(context, listen: false)
        .loadItemsFromServer()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions filter) =>
                filterProvider.favorite = filter == FilterOptions.favorite,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => popupMenuItems,
          ),
          Consumer<CartProvider>(
            builder: (_, cart, __) => Badge(
              value: cart.lenght.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.cartItems);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(filterFavorites: filterProvider.favorite),
      drawer: AppDrawer(),
    );
  }

  List<PopupMenuItem<FilterOptions>> get popupMenuItems {
    return const [
      PopupMenuItem(value: FilterOptions.favorite, child: Text('Favorites')),
      PopupMenuItem(value: FilterOptions.all, child: Text('All')),
    ];
  }
}
