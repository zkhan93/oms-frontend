import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:order/components/PageLoading.dart';
import 'package:order/components/PageMessage.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/AdminOrderDetail.dart';
import 'package:order/services/models/Order.dart';
import 'package:order/services/models/OrderResponse.dart';

class AdminOrderList extends StatefulWidget {
  const AdminOrderList({Key? key}) : super(key: key);

  @override
  State<AdminOrderList> createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  late Future<OrderResponse> _ordersResponse;
  late List<Order> _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Manage Orders")),
        drawer: const AppDrawer(),
        body: FutureBuilder<OrderResponse>(
            initialData: null,
            future: _ordersResponse,
            builder: (BuildContext context,
                AsyncSnapshot<OrderResponse> ordersResponseSnapshot) {
              // TODO: handle paginated response
              if (ordersResponseSnapshot.connectionState !=
                  ConnectionState.done) {
                return const PageLoading(message: "Loading orders...");
              }
              if (!ordersResponseSnapshot.hasData ||
                  ordersResponseSnapshot.data == null) {
                return const PageMessage(
                    title: "No orders available!",
                    subtitle: "Orders will be listed here",
                    icon: Icons.lightbulb_sharp);
              }

              OrderResponse? response = ordersResponseSnapshot.data;
              _items = response!.results;

              return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Order order = _items[index];
                    String createdOn = DateFormat.yMMMEd()
                        .format(DateTime.parse(order.created_on));
                    return Card(
                        child: ManageOrderItemWidget(
                            order: order, createdOn: createdOn));
                  });
            }));
  }

  @override
  void didChangeDependencies() {
    _ordersResponse = _loadOrders();
    super.didChangeDependencies();
  }

  Future<OrderResponse> _loadOrders() {
    // TODO: handle paginated response
    return globals.apiClient.getAllOrders();
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
