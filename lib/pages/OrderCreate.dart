import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;

class OrderCreate extends StatefulWidget {
  const OrderCreate({Key? key}) : super(key: key);

  @override
  State<OrderCreate> createState() => _OrderCreateState();
}

class _OrderCreateState extends State<OrderCreate> {
  List<Map> items = [
    {
      "name": TextEditingController(),
      "quantity": TextEditingController(),
      "unit": TextEditingController()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create New Order"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            _createOrder();
            // .then(() {
            //   Navigator.popAndPushNamed(context, "/orders");
            // }).catchError((error) {
            //   debugPrint("error occurred!");
            // });
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

  _createOrder() {
    var orderItems = [];
    items.forEach((element) {
      var tmp = {};
      element.forEach((key, value) {
        tmp[key] = value.text;
      });
      orderItems.add(tmp);
    });
    var order = {"items": orderItems};
    globals.apiClient.createOrder(order);
  }

  _removeItem(index) {
    debugPrint("$index ");
    setState(() {
      items.removeAt(index);
    });
  }
}
