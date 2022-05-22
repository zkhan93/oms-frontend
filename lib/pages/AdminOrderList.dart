import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:order/components/PageMessage.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/AdminOrderDetail.dart';
import 'package:order/pages/OrderHistory.dart';
import 'package:order/services/models/Order.dart';
import 'package:order/services/models/OrderResponse.dart';
import 'package:provider/provider.dart';

class AdminOrderList extends StatefulWidget {
  const AdminOrderList({Key? key}) : super(key: key);

  @override
  State<AdminOrderList> createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Manage Orders")),
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
                          child: ManageOrderItemWidget(
                              order: order, createdOn: createdOn));
                    });
              }
              return const PageMessage(
                  title: "No orders available!",
                  subtitle: "Orders will be listed here",
                  icon: Icons.lightbulb_sharp);
            })));
  }
}

class ManageOrderItemWidget extends StatelessWidget {
  final Order order;

  final String createdOn;
  const ManageOrderItemWidget({
    Key? key,
    required this.order,
    required this.createdOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text("Order #" + order.id.toString()),
      subtitle: Text("$createdOn\n${order.customer.ship}"),
      trailing: Text("${order.item_count} items"),
      isThreeLine: true,
      onTap: () {
        Future.delayed(const Duration(milliseconds: 200), (() {
          Navigator.pushNamed(context, "/manage-order-detail",
              arguments: AdminOrderDetailArguments(order.id));
        }));
      },
      contentPadding: const EdgeInsets.all(8),
    );
  }
}
