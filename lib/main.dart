import 'package:flutter/material.dart';
import 'package:order/pages/LoginPage.dart';
import 'package:order/pages/OrderCreate.dart';
import 'package:order/pages/OrderDetails.dart';
import 'package:order/pages/OrdersPage.dart';
import 'package:order/pages/SignupPage.dart';
import 'package:order/services/ApiClient.dart';
import 'package:provider/provider.dart';
import 'package:order/globals.dart' as globals;

void main() {
  runApp(MultiProvider(
      providers: [Provider(create: (context) => ApiClient())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String?>(
        future: globals.secureStorage.read(
          key: "token",
        ),
        builder: (BuildContext context, AsyncSnapshot<String?> token) {
          if (token.hasData) {
            return const OrderHistory();
          }
          return const LoginPage();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => const SignUpPage(),
        '/orders': (BuildContext context) => const OrderHistory(),
        '/order-details': (BuildContext context) => const OrderDetails(),
        '/order-create': (BuildContext context) => const OrderCreate(),
      },
    );
  }
}
