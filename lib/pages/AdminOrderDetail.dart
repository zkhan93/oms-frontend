import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/LabelRow.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/services/ApiClient.dart';
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

class AdminOrderDetailArguments {
  final int orderId;
  AdminOrderDetailArguments(this.orderId);
}

class AdminOrderDetails extends StatefulWidget {
  const AdminOrderDetails({Key? key}) : super(key: key);

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class AdminOrderItemsWidget extends StatelessWidget {
  final List<OrderItem> items;
  const AdminOrderItemsWidget({
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
        return AdminOrderItemWidget(item: items[index]);
      },
    );
  }
}

class AdminOrderItemWidget extends StatefulWidget {
  final OrderItem item;

  const AdminOrderItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<AdminOrderItemWidget> createState() => _AdminOrderItemWidgetState();
}

class SetOrderItemPriceDialog extends StatelessWidget {
  final OrderItem item;
  final Function(OrderItem item) callback;

  const SetOrderItemPriceDialog({
    Key? key,
    required this.item,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _priceController =
        TextEditingController(text: item.price);
    return AlertDialog(
        title: const Text("Set Price"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              textAlign: TextAlign.start,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(label: Text("Price")),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              debugPrint("from cancel");
              callback(item);
            },
            child: const Text("Cancel"),
            style: TextButton.styleFrom(primary: Colors.red),
          ),
          TextButton(
              onPressed: () {
                globals.apiClient.updateOrderItem(
                    item.id, {"price": _priceController.text}).then(
                  (value) {
                    Navigator.of(context).pop();
                    debugPrint("from set");
                    callback(value);
                  },
                );
              },
              child: const Text("Set"))
        ]);
  }
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  late Future<OrderDetail> _order;
  late int orderId;

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
                        : "Price not set for one or more items"),
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
                child: AdminOrderItemsWidget(
              items: order.items,
            )),
            fit: FlexFit.loose,
          ),
          Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(children: [
                if (order.state.isNotEmpty &&
                    order.state.toLowerCase() == "delivered")
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        setState(() {
                          _order = _cancelOrder(orderId);
                        });
                      },
                      child: const Text("DOWNLOAD RECEIPT")),
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
                      child: const Text("CANCEL ORDER")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        primary: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      setState(() {
                        // update order to change the state to being processed
                        // _order = _updateOrder(orderId);
                      });
                    },
                    child: const Text("UPDATE ORDER"))
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
    final AdminOrderDetailArguments args =
        ModalRoute.of(context)!.settings.arguments as AdminOrderDetailArguments;
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
    return ApiClient().getOrder(id).catchError((error) {
      debugPrint(error.toString());
      return _dummyOrder;
    });
  }
}

class _AdminOrderItemWidgetState extends State<AdminOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    String price = "";
    if (widget.item.price != null) {
      price = "${globals.rs} ${widget.item.price}";
    }
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SetOrderItemPriceDialog(
                  item: widget.item,
                  callback: (updatedItem) {
                    setState(() {
                      widget.item.price = updatedItem.price;
                    });
                    debugPrint(updatedItem.toJson().toString());
                  });
            });
      },
      dense: true,
      title: Text(
        widget.item.name,
        textAlign: TextAlign.start,
      ),
      subtitle: Text("${widget.item.quantity} ${widget.item.unit}"),
      trailing: price.isEmpty ? const Text("-NOT SET-") : Text(price),
    );
  }
}
