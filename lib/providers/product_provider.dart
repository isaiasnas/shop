import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_expecption.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  int get itemsCount => _items.length;

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> loadProduct() async {
    final response = await http.get('$_baseUrl.json');
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach(
        (productId, product) {
          _items.add(
            Product(
                id: productId,
                description: product['description'],
                title: product['description'],
                price: product['price'],
                imageUrl: product['imageUrl'],
                isFavorite: product['isFavorite']),
          );
        },
      );
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      '$_baseUrl.json',
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      description: product.description,
      title: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null && product.id == null) return;

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      //update server
      await http.patch(
        '$_baseUrl/${product.id}.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete('$_baseUrl/${product.id}.json');
      print(response);
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
