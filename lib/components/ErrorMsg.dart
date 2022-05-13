import 'package:flutter/material.dart';

class ErrorMsg extends StatelessWidget {
  const ErrorMsg({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: errors.length,
            itemBuilder: (context, index) => Center(
                    child: Text(
                  errors[index],
                  style: const TextStyle(color: Colors.red),
                ))));
  }
}
