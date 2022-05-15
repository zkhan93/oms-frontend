import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/OrderDetails.dart';
import 'package:order/services/models/Order.dart';
import 'package:order/services/models/OrderResponse.dart';
import 'package:provider/provider.dart';

import '../components/PageMessage.dart';

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
  late String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Orders"), actions: [
          ...globals.getDefaultActions(context),
        ]),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/order-create");
          },
        ),
        body: FutureProvider<OrdersModel>(
            initialData: OrdersModel(),
            create: (context) async {
              OrderResponse response = await globals.apiClient.getOrders();
              return OrdersModel(orders: response.results);
            },
            child: Consumer<OrdersModel>(
                //                    <--- Consumer
                builder: (context, orderModel, child) {
              if (orderModel.error.isNotEmpty) {
                return Center(
                    widthFactor: 1,
                    child: Text(
                      orderModel.error,
                      textAlign: TextAlign.center,
                    ));
              }
              if (orderModel.orders.isNotEmpty) {
                return ListView.builder(
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
                    });
              }
              return const PageMessage(
                  title: "You have not placed any orders!",
                  subtitle:
                      "Your orders will be listed here\n Click on + icon to create new order",
                  icon: Icons.sentiment_dissatisfied_sharp);
            })));
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessage());
  }

  showMessage() {
    final OrdersPageArguments? args =
        ModalRoute.of(context)!.settings.arguments as OrdersPageArguments?;

    if (args?.message != null) {
      SnackBar snackBar = SnackBar(
          content: Text(args!.message),
          backgroundColor: Colors.green,
          action: SnackBarAction(
              textColor: Colors.white,
              label: "OK",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class OrdersPageArguments {
  final String message;
  OrdersPageArguments(this.message);
}
