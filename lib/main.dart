import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/auth/login_screen.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/order_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_overview_screen.dart';
import 'package:shop/views/products_screen.dart';
import 'package:shop/views/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        //ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
            update: (context, auth, previous) => ProductProvider(auth.token,
                auth.userId, previous == null ? [] : previous.items)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        //ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
            update: (context, auth, previous) => OrderProvider(auth.token,
                auth.userId, previous == null ? [] : previous.items)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Minha loja',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            //AppRoutes.LOGIN: (ctx) => LoginScreen(),

            AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
            AppRoutes.PRODUCT_DETAILS: (ctx) => ProductDetailScreen(),
            AppRoutes.CART: (ctx) => CartScreen(),
            AppRoutes.ORDERS: (ctx) => OrderScreen(),
            AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
            AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
          },
        ),
      ),
    );
  }
}
