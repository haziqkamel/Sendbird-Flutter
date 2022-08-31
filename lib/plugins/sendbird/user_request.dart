import 'dart:io';

import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_sdk/core/models/file_info.dart';

Future<void> updateUserInfo({
  String? nickName,
  File? file,
  String? fileUrl,
}) async {
  final BaseAuth authentication = Get.find<AuthenticationController>();
  FileInfo? fileInfo;

  try {
    // If using url
    if (fileUrl != null && fileUrl != '') {
      fileInfo = FileInfo.fromUrl(url: fileUrl);
    } else {
      if (file == null) {
        return;
      }
      print('Converting file into FileInfo');
      fileInfo = FileInfo(file: file);
      print(fileInfo.toJson());
    }

    await authentication.updateCurrentInfo(
      nickname: nickName == '' ? null : nickName,
      file: fileInfo,
    );
  } catch (e) {
    rethrow;
  }
}
