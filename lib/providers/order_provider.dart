import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/utils/constants.dart';

class OrderProvider with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];

  OrderProvider(this.authToken, this.userId, this._items);

  List<Order> get items => [..._items];

  final String authToken;
  final String userId;

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get('$_baseUrl/$userId.json?auth=$authToken');
    Map<String, dynamic> data = json.decode(response.body);

    if (data != null) {
      data.forEach(
        (orderId, order) {
          loadedItems.add(
            Order(
              id: orderId,
              total: order['total'],
              date: DateTime.parse(order['date']),
              products: (order['products'] as List<dynamic>).map((item) {
                return CartItem(
                  id: item['id'],
                  price: item['price'],
                  productId: item['productId'],
                  quantity: item['quantity'],
                  title: item['title'],
                );
              }).toList(),
            ),
          );
        },
      );
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(CartProvider cart) async {
    final date = DateTime.now();
    final response = await http.post('$_baseUrl/$userId.json?auth=$authToken',
        body: json.encode({
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((item) => {
                    'id': item.id,
                    'productId': item.productId,
                    'title': item.title,
                    'quantity': item.quantity,
                    'price': item.price
                  })
              .toList()
        }));

    _items.insert(
      0,
      Order(
          id: json.decode(response.body)['name'],
          total: cart.totalAmount,
          date: DateTime.now(),
          products: cart.items.values.toList()),
    );
    notifyListeners();
  }
}
