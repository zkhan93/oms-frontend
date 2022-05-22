import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/AppDrawer.dart';
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

class OrderItemWidget extends StatelessWidget {
  final Order order;

  final String createdOn;
  const OrderItemWidget({
    Key? key,
    required this.order,
    required this.createdOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text("Order #" + order.id.toString()),
      trailing: Text("${order.item_count} items"),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 200), (() {
          Navigator.pushNamed(context, "/order-detail",
              arguments: OrderDetailArguments(order.id));
        }));
      },
      contentPadding: const EdgeInsets.all(8),
      subtitle: Text(createdOn),
    );
  }
}

class OrdersModel {
  List<Order> orders;
  String error;
  OrdersModel({this.orders = const [], this.error = ""});
}

class OrdersPageArguments {
  final String message;
  OrdersPageArguments(this.message);
}

class _OrderHistoryState extends State<OrderHistory> {
  late String? message;
  // List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
    // globals.getDefaultActions(context).then((value) {
    //   setState(() {
    //     actions = value;
    //   });
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessage());
  }

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
        drawer: const AppDrawer(),
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
                      String createdOn = DateFormat.yMMMEd()
                          .format(DateTime.parse(order.created_on));
                      return Card(
                          child: OrderItemWidget(
                              order: order, createdOn: createdOn));
                    });
              }
              return const PageMessage(
                  title: "You have not placed any orders!",
                  subtitle:
                      "Your orders will be listed here\n Click on + icon to create new order",
                  icon: Icons.lightbulb_sharp);
            })));
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
