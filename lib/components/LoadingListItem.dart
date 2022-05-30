import 'package:flutter/material.dart';

class LoadingListItem extends StatelessWidget {
  const LoadingListItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Loading more orders ..."),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
            )
          ],
        ));
  }
}
