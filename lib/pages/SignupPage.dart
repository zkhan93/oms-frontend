import 'package:flutter/material.dart';
import 'package:order/globals.dart' as globals;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _error = "";
  String? shipName;
  String? shipSupervisorName;
  String? contactNumber;
  String? password;
  final TextEditingController _passwordController = TextEditingController();
  List<String>? shipErrors = [];
  List<String>? supervisorErrors = [];
  List<String>? contactErrors = [];
  List<String>? passwordErrors = [];
  List<String>? commonErrors = [];
  _register() async {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    setState(() {
      shipErrors = null;
      supervisorErrors = null;
      contactErrors = null;
      passwordErrors = null;
      _error = "";
    });

    if (_formKey.currentState!.validate()) {
      // Process data.
      _formKey.currentState?.save();
      var data = {
        "ship": shipName,
        "supervisor": shipSupervisorName,
        "contact": contactNumber,
        "password": password
      };
      setState(() {
        _loading = true;
      });
      try {
        await globals.apiClient.register(data);
        setState(() {
          _loading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Signup complete"),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(
                    Icons.check_circle_sharp,
                    color: Colors.green,
                    size: 72,
                  ),
                  Text(
                    "Wait for the admin to approve you account before login",
                    textAlign: TextAlign.center,
                  ),
                ]),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            });
      } catch (e) {
        debugPrint(e.toString());
        Map? response = globals.getErrorResponse(e);
        debugPrint(response.toString());
        setState(() {
          _loading = false;
          if (response == null) {
            _error = "Failed to register: ${globals.getErrorMsg(e)}";
          } else {
            shipErrors = response["ship"]?.cast<String>();
            supervisorErrors = response["supervisor"]?.cast<String>();
            contactErrors = response["contact"]?.cast<String>();
            passwordErrors = response["password"]?.cast<String>();
            commonErrors = response["non_field_errors"]?.cast<String>();
            _formKey.currentState!.validate();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) {
                              shipName = value;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.sailing),
                                labelText: 'Ship name'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ship name';
                              }
                              if (shipErrors?.isNotEmpty ?? false) {
                                return shipErrors?.join(",");
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              shipSupervisorName = value;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.admin_panel_settings),
                              labelText: 'Ship supervisor name',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ship supervisor name';
                              }
                              if (supervisorErrors?.isNotEmpty ?? false) {
                                return supervisorErrors?.join(",");
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              contactNumber = value;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.person), labelText: 'Contact'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter you contact number';
                              }
                              if (contactErrors?.isNotEmpty ?? false) {
                                return contactErrors!.join(",");
                              }
                              // check with api username should be unique
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              password = value;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.password),
                                labelText: 'Password'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please password';
                              }
                              if (passwordErrors?.isNotEmpty ?? false) {
                                return contactErrors?.join(",");
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              labelText: 'Confirm Password',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm password';
                              }
                              if (value != _passwordController.text) {
                                return 'Please do not match';
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                          ),
                          if (_error.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                _error,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.red),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () => _register(),
                              child: _loading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Sign Up'),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text("Already have an account ?")),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 8.0, 16.0, 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ]),
                  )))),
    );
  }
}
