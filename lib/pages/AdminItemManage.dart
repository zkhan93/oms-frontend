import 'package:flutter/material.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:order/components/PageMessage.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/services/models/Item.dart';
import 'package:order/services/models/ItemsResponse.dart';

class AdminItemManage extends StatefulWidget {
  const AdminItemManage({Key? key}) : super(key: key);

  @override
  State<AdminItemManage> createState() => _AdminItemManageState();
}

class _AdminItemManageState extends State<AdminItemManage> {
  late Future<ItemsResponse> _itemResponse;
  late List<Item> _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Manage Items")),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ItemsResponse>(
            initialData: null,
            future: _itemResponse,
            builder: (BuildContext context,
                AsyncSnapshot<ItemsResponse> itemsResponseSnapshot) {
              debugPrint(itemsResponseSnapshot.data.toString());
              if (!itemsResponseSnapshot.hasData ||
                  itemsResponseSnapshot.data == null) {
                return const PageMessage(
                    title: "No items to manage",
                    icon: Icons.lightbulb,
                    subtitle: "Items in the system will be available here");
              }
              ItemsResponse? response = itemsResponseSnapshot.data;
              _items = response!.results;

              return ListView.builder(
                  itemCount: _items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      _buildItem(context, index, _items[index]));
            },
          ),
        ));
  }

  _buildItem(context, index, item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text("${globals.rs} ${item.default_price}"),
      onTap: () {
        _showEditPrice(context, index, item);
      },
    );
  }

  _showEditPrice(context, index, item) {
    var _valueController = TextEditingController(text: item.default_price);
    var alert = AlertDialog(
      title: const Text("Set Price"),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
            ),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(label: Text("price")),
            )
          ]),
      actions: [
        TextButton(
            onPressed: () {
              _updateItem(item, _valueController.text).then((updatedItem) {
                setState(() {
                  _items[index] = updatedItem;
                });
                Navigator.of(context).pop();
              });
            },
            child: const Text("OK"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future<Item> _updateItem(item, price) async {
    Item updatedItem =
        await globals.apiClient.updateItem(item.id, {"default_price": price});
    return updatedItem;
  }

  @override
  void didChangeDependencies() {
    _itemResponse = _loadItems();
    super.didChangeDependencies();
  }

  Future<ItemsResponse> _loadItems() {
    return globals.apiClient.getItems();
  }
}
