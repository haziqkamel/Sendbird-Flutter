import 'package:flutter/widgets.dart';

Padding customPadding({
  required Widget widget,
  double horizontalPadding = 20,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
    ),
    child: widget,
  );
}
