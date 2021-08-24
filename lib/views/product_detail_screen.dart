import 'package:flutter/material.dart';
import '../providers/product_item_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductItemProvider product =
        ModalRoute.of(context)!.settings.arguments! as ProductItemProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text('R\$ ${product.price}'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(product.description, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
