import 'package:flutter/material.dart';

class OrderDeliveryArguments {
  final int orderId;

  OrderDeliveryArguments(this.orderId);
}

class OrderDelivery extends StatelessWidget {
  const OrderDelivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("haha"),
    );
  }
}
