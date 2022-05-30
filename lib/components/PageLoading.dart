import 'package:flutter/material.dart';

class PageLoading extends StatelessWidget {
  final String message;
  const PageLoading({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    ));
  }
}
