import 'package:flutter/material.dart';
import 'package:order/pages/OrderDetails.dart';
import 'package:order/pages/OrderHistory.dart';
import 'package:order/services/models/Order.dart';
import 'package:provider/provider.dart';

var OrderCard = Consumer<OrdersModel>(
    //                    <--- Consumer
    builder: (context, orderModel, child) {
  return Column(children: [
    if (orderModel.error.isNotEmpty) Text(orderModel.error),
    if (orderModel.orders.isNotEmpty)
      ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4),
          itemCount: orderModel.orders.length,
          itemBuilder: (BuildContext context, int index) {
            Order order = orderModel.orders[index];
            return Card(
                child: ListTile(
              leading: const Icon(Icons.person),
              title: Text("Order #" + order.id.toString()),
              isThreeLine: true,
              onTap: () {
                Navigator.pushNamed(context, "/order-detail",
                    arguments: OrderDetailArguments(order.id));
              },
              contentPadding: const EdgeInsets.all(8),
              subtitle: Text(order.customer.toString()),
            ));
          }),
    if (orderModel.orders.isEmpty) const Text("No items")
  ]);
});
