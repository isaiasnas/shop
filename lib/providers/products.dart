import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;
  // bool _showFavoriteOnly = false;

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((produto) => produto.isFavorite).toList();
    // } else {
    return [..._items];
    // }
  }

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
