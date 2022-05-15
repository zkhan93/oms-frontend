import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/OrderHistory.dart';
import 'package:order/services/models/OrderDetail.dart';

class OrderCreate extends StatefulWidget {
  const OrderCreate({Key? key}) : super(key: key);

  @override
  State<OrderCreate> createState() => _OrderCreateState();
}

class _OrderCreateState extends State<OrderCreate> {
  bool loading = false;
  List<Map> items = [
    {
      "name": TextEditingController(),
      "quantity": TextEditingController(),
      "unit": TextEditingController()
    }
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Create New Order"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            // setState(() {
            //   loading = true;
            // });
            _createOrder().then((newOrder) {
              debugPrint("order created ${newOrder.toJson()}");
              // setState(() {
              //   loading = false;
              // });
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, "/orders",
                  arguments: OrdersPageArguments("Order created successfully"));
            }).catchError((error) {
              debugPrint("error occurred!");
              // setState(() {
              //   loading = true;
              // });
            });
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Map item = items[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          flex: 3,
                          child: TextFormField(
                            controller: item["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Item Name',
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: TextFormField(
                            controller: item["quantity"],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                          )),
                      Flexible(
                          child: TextFormField(
                        controller: item["unit"],
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                        ),
                      )),
                      IconButton(
                        color: Colors.red,
                        tooltip: 'Delete this entry',
                        onPressed: () {
                          _removeItem(index);
                        },
                        icon: const Icon(Icons.remove),
                      )
                    ],
                  );
                }),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () => _addItem(), child: const Text("Add More")),
              ),
            )
          ]),
        ));
  }

  _addItem() {
    setState(() {
      items.add({
        "name": TextEditingController(),
        "quantity": TextEditingController(),
        "unit": TextEditingController(),
      });
    });
  }

  Future<OrderDetail> _createOrder() {
    var orderItems = [];
    items.forEach((element) {
      var tmp = {};
      element.forEach((key, value) {
        tmp[key] = value.text;
      });
      orderItems.add(tmp);
    });
    var order = {"items": orderItems};
    return globals.apiClient.createOrder(order);
  }

  _removeItem(index) {
    debugPrint("$index ");
    setState(() {
      items.removeAt(index);
    });
  }
}
