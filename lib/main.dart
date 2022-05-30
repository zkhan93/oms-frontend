import 'package:flutter/material.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:order/pages/AdminItemManage.dart';
import 'package:order/pages/AdminOrderDetail.dart';
import 'package:order/pages/AdminOrderList.dart';
import 'package:order/pages/LoginPage.dart';
import 'package:order/pages/OrderCreate.dart';
import 'package:order/pages/OrderDetails.dart';
import 'package:order/pages/OrderHistory.dart';
import 'package:order/pages/SetDelivery.dart';
import 'package:order/pages/SignupPage.dart';
import 'package:provider/provider.dart';
import 'package:order/globals.dart' as globals;
import 'package:flutter/widgets.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DrawerStateInfo>(
        create: (context) => DrawerStateInfo()),
  ], child: const MyApp()));
}

var routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => const LoginPage(),
  '/sign-up': (BuildContext context) => const SignUpPage(),
  '/order-list': (BuildContext context) => const OrderHistory(),
  '/order-detail': (BuildContext context) => const OrderDetails(),
  '/order-create': (BuildContext context) => const OrderCreate(),
  '/manage-products': (BuildContext context) => const AdminItemManage(),
  '/manage-orders': (BuildContext context) => const AdminOrderList(),
  '/manage-order-detail': (BuildContext context) => const AdminOrderDetails(),
  '/order-delivery': (BuildContext context) => const OrderDelivery(),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
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
          // buttonTheme: ,

          textTheme: Typography().black.apply(fontFamily: "Quicksand"),
          // TextTheme(
          //     titleSmall: TextStyle(fontSize: 14.0, fontFamily: "OpenSans"),
          //     titleMedium: TextStyle(fontSize: 15.0, fontFamily: "OpenSans"),
          //     titleLarge: TextStyle(fontSize: 16.0, fontFamily: "OpenSans"),
          //     button: TextStyle(fontWeight: FontWeight.bold)
          //     // labelSmall: const TextStyle(fontSize: 12.0),
          //     // bodyText1: const TextStyle(fontSize: 12.0),
          //     // bodyText2: const TextStyle(fontSize: 14.0),
          //     // button: const TextStyle(fontSize: 14.0),
          //     ),
          primarySwatch: Colors.blue,
          errorColor: Colors.red[300]),
      initialRoute: "/",
      home: FutureBuilder<String?>(
        future: globals.secureStorage.read(
          key: "token",
        ),
        builder: (BuildContext context, AsyncSnapshot<String?> token) {
          debugPrint("token data ${token.hasData} ${token.data}");
          if (!token.hasData || token.data == null) {
            return const LoginPage();
          }
          return const OrderHistory();
        },
      ),
      // routes: routes,
      onGenerateRoute: (settings) {
        debugPrint("animating ${settings.name}");

        return PageRouteBuilder(
          settings:
              settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
          pageBuilder: (_, __, ___) => routes[settings.name]!(context),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        );

        // Unknown route
        // return MaterialPageRoute(builder: (_) => UnknownPage());
      },
    );
  }
}
