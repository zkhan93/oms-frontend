import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                            decoration: const InputDecoration(
                              icon: Icon(Icons.face),
                              labelText: 'Full name',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Email address',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.sailing),
                              labelText: 'Ship name',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ship name';
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.admin_panel_settings),
                              labelText: 'Ship supervisor name',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ship supervisor name';
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Username',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              // check with api username should be unique
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
                              labelText: 'Password',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please password';
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
                              return null;
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState!.validate()) {
                                  // Process data.
                                }
                              },
                              child: const Text('Sign Up'),
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
