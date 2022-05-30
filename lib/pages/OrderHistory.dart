import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:order/components/LoadingListItem.dart';
import 'package:order/components/PageLoading.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/pages/OrderDetails.dart';
import 'package:order/services/models/Order.dart';

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
      subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(createdOn), Text("Status: ${order.state}")]),
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
  List<Order> _orders = [];
  bool _loading = false;
  bool _allLoaded = false;
  String _error = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_loading && !_allLoaded) _loadOrders();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessage());
  }

  _reload() {
    setState(() {
      _orders = [];
      _loading = true;
    });
    return globals.apiClient
        .getOrders({"limit": 10, "offset": _orders.length}).then((value) {
      setState(() {
        _orders = value.results;
        _loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _error = globals.getErrorMsg(error);
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
        body: RefreshIndicator(
            onRefresh: () {
              return _reload();
            },
            child: _error.isNotEmpty
                ? PageMessage(
                    title: "Error encountered!",
                    subtitle: _error,
                    icon: Icons.error,
                    color: Colors.red[300],
                    action: () {
                      _error = "";
                      _reload();
                    },
                    actionName: "RETRY",
                  )
                : _orders.isEmpty
                    ? (_loading
                        ? const PageLoading(message: "Loading orders...")
                        : const PageMessage(
                            title: "You have not placed any orders!",
                            subtitle:
                                "Your orders will be listed here\n Click on + icon to create new order",
                            icon: Icons.lightbulb_sharp))
                    : ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        itemCount: _orders.length + (_allLoaded ? 0 : 1),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _orders.length) {
                            return const LoadingListItem();
                          }
                          Order order = _orders[index];
                          String createdOn = DateFormat.yMMMEd()
                              .format(DateTime.parse(order.created_on));
                          return Card(
                              child: OrderItemWidget(
                                  order: order, createdOn: createdOn));
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

  _loadOrders() {
    setState(() {
      _loading = true;
      _error = "";
    });
    globals.apiClient
        .getOrders({"limit": 10, "offset": _orders.length}).then((value) {
      setState(() {
        _orders.addAll(value.results);
        _allLoaded = value.count == _orders.length;
        _loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
        _error = globals.getErrorMsg(error);
      });
    });
  }
}
