import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/OrderDetails.dart';
import 'package:order/services/models/Order.dart';
import 'package:order/services/models/OrderResponse.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class OrdersModel {
  List<Order> orders;
  String error;
  OrdersModel({this.orders = const [], this.error = ""});
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/order-create");
          },
        ),
        body: Center(
            child: FutureProvider<OrdersModel>(
                initialData: OrdersModel(),
                create: (context) async {
                  OrderResponse response = await globals.apiClient.getOrders();
                  return OrdersModel(orders: response.results);
                },
                child: Consumer<OrdersModel>(
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
                                Navigator.pushNamed(context, "/order-details",
                                    arguments: OrderDetailArguments(order.id));
                              },
                              contentPadding: const EdgeInsets.all(8),
                              subtitle: Text(order.customer.ship +
                                  "\n" +
                                  order.item_count.toString() +
                                  " items"),
                            ));
                          }),
                    if (orderModel.orders.isEmpty) const Text("No items")
                  ]);
                }))));
  }

  @override
  initState() {
    super.initState();
  }
}
