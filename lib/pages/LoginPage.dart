import 'package:flutter/material.dart';
import 'package:order/components/ErrorMsg.dart';
import 'package:order/components/Loading.dart';
import 'package:order/globals.dart' as globals;
import 'package:order/services/models/Token.dart';

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
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome!",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                          child: Text(
                            "Order fresh fruits and vegetables",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Contact Number',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter contact number';
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
                    obscureText: _obscurePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        suffix: GestureDetector(
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )),
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
                  ErrorMsg(errors: errors),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size.fromHeight(40),
                            fixedSize: const Size.fromHeight(40)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            doLogin();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (loading)
                              const SizedBox(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                                height: 24,
                                width: 24,
                              ),
                            if (!loading) const Text('Login')
                          ],
                        ),
                      )),
                  Center(
                    child: Container(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "/sign-up");
                                })
                          ],
                        )),
                  )
                ]),
          ),
        ),
      ),
    );
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
        .then((Token token) async {
      await Future.wait([
        if (token.customerId != null)
          globals.fetchUserDetails(token.customerId!),
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
