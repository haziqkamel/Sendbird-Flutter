import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DialogType { oneButton, twoButton }

Future<void> customDialog(
  BuildContext context, {
  DialogType type = DialogType.twoButton,
  String? title,
  String? content,
  Function? onTap1,
  String? buttonText1,
  Function? onTap2,
  String? buttonText2,
}) async {
  switch (type) {
    case DialogType.oneButton:
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: title == null ? null : Text(title),
          content: content == null ? null : Text(content),
          actions: [
            TextButton(
              child: Text(buttonText1 ?? 'Approve'),
              onPressed: () async {
                if (onTap1 != null) {
                  await onTap1();
                }
                Get.back();
              },
            ),
          ],
        ),
      ).then(
        (value) {},
      );
      break;

    case DialogType.twoButton:
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: title == null ? null : Text(title),
          content: content == null ? null : Text(content),
          actions: [
            TextButton(
              child: Text(buttonText1 ?? 'Approve'),
              onPressed: () async {
                if (onTap1 != null) {
                  await onTap1();
                }
                Get.back();
              },
            ),
            TextButton(
              child: Text(buttonText2 ?? 'Cancel'),
              onPressed: () async {
                if (onTap2 != null) {
                  await onTap2();
                }
                Get.back();
              },
            ),
          ],
        ),
      ).then(
        (value) {},
      );
  }
}
