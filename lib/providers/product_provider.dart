import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_expecption.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductProvider with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';

  List<Product> _items = [];

  ProductProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;

  int get itemsCount => _items.length;

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> loadProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final response =
        await http.get('$_baseUrl.json?auth=$authToken&$filterString');
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();

    final String _url =
        '${Constants.BASE_API_URL}/userFavorite/$userId.json?auth=$authToken';

    final favoriteResponse = await http.get(_url);
    final favoriteDate = json.decode(favoriteResponse.body);

    //print(favoriteDate);

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
              isFavorite: favoriteDate == null
                  ? false
                  : favoriteDate[productId] ?? false,
            ),
          );
        },
      );
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      '$_baseUrl.json?auth=$authToken',
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
        //'isFavorite': product.isFavorite,
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
        '$_baseUrl/${product.id}.json?auth=$authToken',
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

      final response =
          await http.delete('$_baseUrl/${product.id}.json?auth=$authToken');
      //print(response);
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
