import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order/app.dart';
import 'package:order/components/AppDrawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  try {
    await dotenv.load(mergeWith: {});
  } catch (ex) {
    debugPrint(ex.toString());
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DrawerStateInfo>(
        create: (context) => DrawerStateInfo()),
  ], child: const MyApp()));
}
