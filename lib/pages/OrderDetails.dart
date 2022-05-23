import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/LabelRow.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/utils.dart' as utils;
import 'package:order/services/models/Customer.dart';
import 'package:order/services/models/OrderDetail.dart';
import 'package:order/services/models/OrderItem.dart';

OrderDetail _dummyOrder = const OrderDetail(
    comment: "",
    createdOn: "",
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
    total: null,
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
    String price = "";
    if (item.price != null) {
      price = "${globals.rs} ${item.price}";
    }
    return ListTile(
      dense: true,
      title: Text(
        item.name,
        textAlign: TextAlign.start,
      ),
      subtitle: item.price != null ? Text("${globals.rs} ${item.price}") : null,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text("${item.quantity} ${item.unit}"),
        if (price.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(left: 32.0), child: Text(price)),
      ]),
    );
  }
}

class _OrderDetailsState extends State<OrderDetails> {
  late Future<OrderDetail> _order;
  late int orderId;
  bool _downloading = false;

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
        String createdOn =
            DateFormat.yMMMEd().format(DateTime.parse(order.createdOn));

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Order Details",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                LabelRow(label: "Order #", value: "${order.id}"),
                LabelRow(label: "Order Status", value: order.state),
                LabelRow(label: "Order Date", value: createdOn),
                LabelRow(
                    label: "Order Total",
                    value: order.total != null
                        ? "${globals.rs} ${order.total}"
                        : "Price not set for items"),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "${order.items.length} Items in Order",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.start,
            ),
          ),
          Flexible(
            child: Card(
                child: OrderItemsWidget(
              items: order.items,
            )),
            fit: FlexFit.loose,
          ),
          Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(children: [
                // if (order.state.isNotEmpty &&
                //     order.state.toLowerCase() == "delivered")
                if (order.state.isNotEmpty &&
                    ((["delivered", "processing"]
                        .contains(order.state.toLowerCase()))))
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size.fromHeight(40),
                          fixedSize: const Size.fromHeight(40)),
                      onPressed: () async {
                        setState(() {
                          _downloading = true;
                        });
                        await utils.downloadReceipt(orderId);
                        setState(() {
                          _downloading = false;
                        });
                      },
                      child: _downloading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                semanticsLabel: "Downloading Order receipt",
                              ))
                          : const Text("DOWNLOAD RECEIPT")),
                if (order.state.isNotEmpty &&
                    (!(["delivered", "cancelled"]
                        .contains(order.state.toLowerCase()))))
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          primary: Theme.of(context).errorColor,
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        setState(() {
                          _order = _cancelOrder(orderId);
                        });
                      },
                      child: const Text("CANCEL ORDER"))
              ]))
        ]);
      },
    );
    return Scaffold(
        appBar: AppBar(title: const Text("Orders Detail")),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: orderProvider,
        ));
  }

  @override
  void didChangeDependencies() {
    final OrderDetailArguments args =
        ModalRoute.of(context)!.settings.arguments as OrderDetailArguments;
    orderId = args.orderId;
    _order = _loadOrder(orderId);
    super.didChangeDependencies();
  }

  Future<OrderDetail> _cancelOrder(int id) {
    return globals.apiClient
        .updateOrder(id, {"state": "X"}).catchError((error) {
      debugPrint(error.toString());
      return _dummyOrder;
    });
  }

  Future<OrderDetail> _loadOrder(int id) {
    return globals.apiClient.getOrder(id).catchError((error) {
      debugPrint(error.toString());
      return _dummyOrder;
    });
  }
}
