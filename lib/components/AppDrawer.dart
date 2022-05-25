import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;
import 'package:provider/provider.dart';

class DrawerStateInfo with ChangeNotifier {
  int _currentItemIndex = AppDrawerEntry.ORDERS;
  int get getCurrentItemIndex => _currentItemIndex;

  void setSelected(int itemIndex) {
    _currentItemIndex = itemIndex;
    notifyListeners();
  }

  void increment() {
    notifyListeners();
  }
}

class AppDrawerEntry {
  static const ORDERS = 1;
  static const MANAGE_PRODUCTS = 2;
  static const MANAGE_ORDERS = 3;
  static const SETTINGS = 4;
  static const SIGN_OUT = 4;
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _showAdminActions = false;
  List<String> roles = [];
  String name = "";

  @override
  void initState() {
    super.initState();
    globals.getRoles().then((value) {
      setState(() {
        roles = value;
        if (value.contains("admin")) {
          _showAdminActions = true;
        }
      });
    });
    globals.getUser().then((customer) {
      if (customer != null) {
        setState(() {
          name = customer.supervisor;
        });
      }
    });
  }

  setSelection(int index) async {
    Navigator.pop(context);
    Provider.of<DrawerStateInfo>(context, listen: false).setSelected(index);

    if (index == AppDrawerEntry.ORDERS) {
      Navigator.of(context).popAndPushNamed("/order-list");
    } else if (index == AppDrawerEntry.MANAGE_ORDERS) {
      Navigator.of(context).popAndPushNamed("/manage-orders");
    } else if (index == AppDrawerEntry.MANAGE_PRODUCTS) {
      Navigator.of(context).popAndPushNamed("/manage-products");
    } else if (index == AppDrawerEntry.SIGN_OUT) {
      if (await globals.secureStorage.containsKey(key: "token")) {
        await globals.secureStorage.delete(key: "token");
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
      Provider.of<DrawerStateInfo>(context, listen: false)
          .setSelected(AppDrawerEntry.ORDERS);
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentItemIndex =
        Provider.of<DrawerStateInfo>(context).getCurrentItemIndex;
    var _adminChildren = [
      const Divider(
        height: 1,
        thickness: 1,
      ),
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Admin',
        ),
      ),
      ListTile(
        leading: const Icon(Icons.list_sharp),
        title: const Text('Manage Products'),
        selected: currentItemIndex == AppDrawerEntry.MANAGE_PRODUCTS,
        onTap: () => setSelection(AppDrawerEntry.MANAGE_PRODUCTS),
      ),
      ListTile(
        leading: const Icon(Icons.sell_outlined),
        title: const Text('Manage Orders'),
        selected: currentItemIndex == AppDrawerEntry.MANAGE_ORDERS,
        onTap: () => setSelection(AppDrawerEntry.MANAGE_ORDERS),
      )
    ];
    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: ListTile(
            leading: const Icon(
              Icons.account_circle_outlined,
              size: 48,
            ),
            title: Text(name, style: Theme.of(context).textTheme.headline6),
            subtitle: roles.contains("admin")
                ? const Text("Admin")
                : const Text("Customer"),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sell),
          title: const Text('Orders'),
          selected: currentItemIndex == AppDrawerEntry.ORDERS,
          onTap: () => setSelection(AppDrawerEntry.ORDERS),
        ),
        if (_showAdminActions) ..._adminChildren,
        const Divider(
          height: 1,
          thickness: 1,
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Account',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          enabled: false,
          title: const Text('Settings'),
          selected: currentItemIndex == AppDrawerEntry.SETTINGS,
          onTap: () => setSelection(AppDrawerEntry.SETTINGS),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle_sharp),
          title: const Text('Sign out'),
          selected: currentItemIndex == AppDrawerEntry.SIGN_OUT,
          onTap: () => setSelection(AppDrawerEntry.SIGN_OUT),
        ),
      ],
    ));
  }
}
