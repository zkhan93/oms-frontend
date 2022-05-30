import 'package:flutter/material.dart';

class PageMessage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final void Function()? action;
  final String? actionName;
  const PageMessage({
    Key? key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.color,
    this.actionName,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          icon,
          size: 72,
          color: color ?? Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.grey),
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
        if (action != null && actionName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(onPressed: action, child: Text(actionName!)),
          )
      ]),
    );
  }
}
