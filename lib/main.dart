import 'package:flutter/material.dart';
import 'package:shop/providers/counter_provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      child: MaterialApp(
          title: 'Minha loja',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: ProductOverviewScreen(),
          routes: {AppRoutes.PRODUCT_DETAILS: (ctx) => ProductDetailScreen()}),
    );
  }
}
