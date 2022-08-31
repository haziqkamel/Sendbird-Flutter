import 'package:flutter/widgets.dart';

Padding customPadding({
  required Widget widget,
  double horizontalPadding = 20,
  double? verticalPadding,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding ?? 0,
    ),
    child: widget,
  );
}
