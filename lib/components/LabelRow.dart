import 'package:flutter/material.dart';

class LabelRow extends StatelessWidget {
  final String label;

  final String value;

  const LabelRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.start,
              )),
          Flexible(
              flex: 6,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.start,
              ))
        ],
      ),
    );
  }
}
