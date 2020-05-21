import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderProvider>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
          future:
              Provider.of<OrderProvider>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else
              return Consumer<OrderProvider>(builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, index) => OrderWidget(orders.items[index]),
                );
              });
          },
        ),
      ),
    );
  }
}
