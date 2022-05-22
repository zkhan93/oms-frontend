import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order/components/ErrorMsg.dart';
import 'package:order/components/Loading.dart';
import 'package:order/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;
  List<String> errors = [];
  List<String> usernameErrors = [];
  List<String> passwordErrors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Username',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    if (usernameErrors.isNotEmpty) {
                      return usernameErrors.join("\n");
                    }
                    // check with api username should be unique
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.password), labelText: 'Password'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please password';
                    }
                    if (passwordErrors.isNotEmpty) {
                      return passwordErrors.join("\n");
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                if (errors.isNotEmpty) ErrorMsg(errors: errors),
                if (loading) const Loading(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        doLogin();
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text("Don't have an account ?")),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: ElevatedButton(
                        child: const Text("Signup"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/sign-up");
                        }))
              ])),
        ))));
  }

  doLogin() {
    setState(() {
      loading = true;
      errors = [];
      passwordErrors = [];
      usernameErrors = [];
    });
    globals.apiClient
        .getToken(_usernameController.text, _passwordController.text)
        .then((token) async {
      await Future.wait([
        globals.setRoles(token.roles).then((value) {
          debugPrint("role writing : $value");
        }),
        globals.secureStorage.write(value: token.token, key: 'token').then(
            (value) {
          debugPrint("token written successfully");
        }, onError: (value) {
          debugPrint("failed to write token");
        })
      ]);
      setState(() {
        loading = false;
      });
      Navigator.popAndPushNamed(context, "/order-list");
    }).catchError((ex) {
      Map? response = globals.getErrorResponse(ex);

      if (response != null) {
        setState(() {
          loading = false;
          errors = (response["non_field_errors"] ?? []).cast<String>();
          passwordErrors = (response["password"] ?? []).cast<String>();
          usernameErrors = (response["username"] ?? []).cast<String>();
        });
        _formKey.currentState!.validate();
      } else {
        String msg = globals.getErrorMsg(ex);
        setState(() {
          loading = false;
          errors = [msg];
        });
      }
    });
  }
}
