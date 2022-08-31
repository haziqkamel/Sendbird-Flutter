import 'package:flutter/material.dart';

AppBar customAppBar({
  String? title,
  bool includeLeading = true,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.pink,
    centerTitle: false,
    leading: includeLeading
        ? const SizedBox.square(
            dimension: 30,
            child: Icon(Icons.send),
          )
        : null,
    actions: actions,
    title: Text(
      title ?? 'Sendbird Flutter',
      style: const TextStyle(color: Colors.white),
    ),
  );
}
