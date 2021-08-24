import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/filter_provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_manager_screen.dart';

import 'providers/products_provider.dart';
import 'utils/routes.dart';
import 'views/cart_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.productDetal: (_) => ProductDetailScreen(),
          AppRoutes.cartItems: (_) => CartScreen(),
          AppRoutes.order: (_) => OrderScreen(),
          AppRoutes.home: (_) => MyHomePage(),
          AppRoutes.products: (_) => ProductsManagerScreen(),
          AppRoutes.productForm: (_) => ProductFormScreen(),
        },
        initialRoute: AppRoutes.home,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterProvider(),
      child: ProductsOverviewScreen(),
    );
  }
}
