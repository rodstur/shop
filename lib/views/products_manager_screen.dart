import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_manager_item.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductsManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.productForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => productsProvider.loadItemsFromServer(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: productsProvider.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return ProductManagerItem(productsProvider.items[index]);
            },
          ),
        ),
      ),
    );
  }
}
