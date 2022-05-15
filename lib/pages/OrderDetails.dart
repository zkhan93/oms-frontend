import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/services/ApiClient.dart';
import 'package:order/services/models/Customer.dart';
import 'package:order/services/models/OrderDetail.dart';
import 'package:order/services/models/OrderItem.dart';

OrderDetail _dummyOrder = const OrderDetail(
    comment: "",
    created_on: "",
    id: 0,
    customer: Customer(
      id: 1,
      name: "",
      username: "",
      user: 1,
      contact: "",
      ship: "",
      supervisor: "",
    ),
    items: [],
    state: "");

class OrderDetailArguments {
  final int orderId;
  OrderDetailArguments(this.orderId);
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class OrderItemsWidget extends StatelessWidget {
  final List<OrderItem> items;
  const OrderItemsWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.isEmpty ? 1 : items.length,
      itemBuilder: (context, index) {
        if (items.isEmpty) return const Text("No Items");
        return OrderItemWidget(item: items[index]);
      },
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final OrderItem item;

  const OrderItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dining),
      title: Text(
        item.name,
        textAlign: TextAlign.start,
      ),
      trailing: Text("${item.quantity} ${item.unit}"),
    );
  }
}

class _OrderDetailsState extends State<OrderDetails> {
  late Future<OrderDetail> _order;
  late int orderId;

  @override
  void didChangeDependencies() {
    final OrderDetailArguments args =
        ModalRoute.of(context)!.settings.arguments as OrderDetailArguments;
    orderId = args.orderId;
    _order = _loadOrder(orderId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("orderId $orderId");

    var orderProvider = FutureBuilder<OrderDetail>(
      initialData: null,
      future: _order,
      builder:
          (BuildContext context, AsyncSnapshot<OrderDetail> orderSnapshot) {
        if (!orderSnapshot.hasData || orderSnapshot.data == null) {
          return const Text("Details not found!");
        }
        OrderDetail order = orderSnapshot.data as OrderDetail;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Order #${order.id}",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Text(
              "Status: ${order.state}",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.start,
            ),
            Text(
              "Created At: ${order.created_on}",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.start,
            ),
            OrderItemsWidget(
              items: order.items,
            ),
            const Divider(
              thickness: 2,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            Text(
              "Total ${order.items.length} Items",
              textAlign: TextAlign.start,
            ),
            Text(
              "Order Status: ${order.state}",
              textAlign: TextAlign.start,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                ),
                onPressed: () {
                  setState(() {
                    _order = _cancelOrder(orderId);
                  });
                },
                child: const Text("Cancel")),
          ],
        );
      },
    );
    return Scaffold(
        appBar: AppBar(title: const Text("Orders Detail"), actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
        ]),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
          child: orderProvider,
        ));
  }

  Future<OrderDetail> _cancelOrder(int id) async {
    return await globals.apiClient
        .updateOrder(id, {"state": "X"}).catchError((error) {
      debugPrint(error.toString());
      return _dummyOrder;
    });
  }

  Future<OrderDetail> _loadOrder(int id) async {
    return await ApiClient().getOrder(id).catchError((error) {
      debugPrint(error.toString());
      return _dummyOrder;
    });
  }
}
