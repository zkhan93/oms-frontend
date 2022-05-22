import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/components/PageMessage.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/OrderHistory.dart';

class OrderCreate extends StatefulWidget {
  const OrderCreate({Key? key}) : super(key: key);

  @override
  State<OrderCreate> createState() => _OrderCreateState();
}

class _OrderCreateState extends State<OrderCreate> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addItemKey = GlobalKey<FormState>();
  final Map emptyItem = {
    "name": "",
    "quantity": "",
    "unit": "kg",
  };
  bool loading = false;
  int updateIndex = -1;
  List<Map> items = [];
  Map currentItem = {
    "name": "",
    "quantity": "",
    "unit": "kg",
  };
  @override
  Widget build(BuildContext context) {
    var itemsListView = AnimatedList(
        key: _listKey,
        shrinkWrap: true,
        initialItemCount: items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(context, index, animation);
        });
    var emptyListView = const PageMessage(
        title: "No items!",
        icon: Icons.lightbulb_sharp,
        subtitle: "Add Items using below form!");
    var addItemCardForm = Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _addItemKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        currentItem["name"] = value;
                      },
                      controller:
                          TextEditingController(text: currentItem["name"]),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                      ),
                    ),
                  ),
                  Row(children: [
                    Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              currentItem["quantity"] = value;
                            },
                            controller: TextEditingController(
                                text: currentItem["quantity"]),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Quantity is required';
                              }
                              if (double.parse(value) == 0) {
                                return 'Quantity must me more that zero';
                              }
                              return null;
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                          ),
                        )),
                    Flexible(
                        child: DropdownButtonFormField(
                      value: currentItem["unit"],
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          child: Text("Kg"),
                          value: "kg",
                        )
                      ],
                      onChanged: (value) {
                        currentItem["unit"] = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                      ),
                    )),
                  ]),
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: if there is content in currentItem (if either name or quantity has non empty data)
                            // ask user to add it first before creating order
                            _createOrder();
                          },
                          child: const Text(
                            "CREATE ORDER",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_addItemKey.currentState!.validate()) {
                              _addOrUpdateItem();
                            }
                          },
                          child: Text(
                              "${updateIndex == -1 ? 'ADD' : 'UPDATE'} ITEM"),
                        ),
                      ])
                ],
              )),
        ));
    var itemsSummary = Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          "${items.length} items",
          textAlign: TextAlign.start,
        ));
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Text("Create New Order"), actions: [
          // ...globals.getDefaultActions(context),
        ]),
        body: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Flexible(
              fit: FlexFit.tight,
              child: items.isNotEmpty ? itemsListView : emptyListView),
          if (items.isNotEmpty) itemsSummary,
          addItemCardForm
        ]));
  }

  _buildStaleItem(context, item, animation) {
    var entryItem = ListTile(
      trailing: IconButton(
          color: Colors.red,
          splashColor: Colors.red[300],
          onPressed: () {},
          icon: const Icon(Icons.remove)),
      title: Text(item["name"]),
      subtitle: Text("${item['quantity']} ${item['unit']}"),
    );
    return entryItem;
  }

  _buildItem(context, index, animation) {
    Map item = items[index];
    var entryItem = ListTile(
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            tooltip: "Edit",
            color: Colors.grey,
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 200), (() {
                setState(() {
                  updateIndex = index;
                  currentItem = Map.from(items[index]);
                });
              }));
            },
            icon: const Icon(Icons.edit)),
        Flexible(
            child: IconButton(
                tooltip: "Remove",
                color: Colors.red,
                splashColor: Colors.red[300],
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 200),
                      (() => _removeItem(index)));
                },
                icon: const Icon(Icons.remove)))
      ]),
      title: Text(item["name"]),
      subtitle: Text("${item['quantity']} ${item['unit']}"),
    );
    return ScaleTransition(
      child: entryItem,
      scale: animation,
    );
  }

  _addOrUpdateItem() {
    setState(() {
      if (updateIndex != -1) {
        items[updateIndex] = currentItem;
        updateIndex = -1;
      } else {
        items.add(currentItem);
        _listKey.currentState?.insertItem(items.length - 1);
      }
      currentItem = Map.from(emptyItem);
    });
  }

  _createOrder() {
    var order = {"items": items};
    globals.apiClient.createOrder(order).then((newOrder) {
      debugPrint("order created ${newOrder.toJson()}");
      // setState(() {
      //   loading = false;
      // });
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, "/order-list",
          arguments: OrdersPageArguments("Order created successfully"));
    }).catchError((error) {
      debugPrint("error occurred!");
      // setState(() {
      //   loading = true;
      // });
    });
  }

  _removeItem(index) {
    var removedItem = items[index];
    _listKey.currentState?.removeItem(
        index,
        ((context, animation) =>
            _buildStaleItem(context, removedItem, animation)),
        duration: const Duration(milliseconds: 300));
    setState(() {
      items.removeAt(index);
      if (updateIndex != -1) {
        if (index < updateIndex) {
          // an item above editing item was removed
          updateIndex -= 1;
        } else if (index == updateIndex) {
          // editing item was deleted
          updateIndex = -1;
          currentItem = Map.from(emptyItem);
        }
      }
    });
  }
}
