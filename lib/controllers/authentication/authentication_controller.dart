import 'package:get/get.dart';
import 'package:sendbird_flutter/utils/constants.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

abstract class BaseAuth {
  Future<User> login({
    required String userId,
    String? nickname,
    String? accessToken,
    String? apiHost,
    String? wsHost,
  });

  Future<void> logout();
  User? get currentUser;
  bool get isSigned;
  Future<void> dispose();
  SendbirdSdk get sendbirdSdk;
  Future<void> updateCurrentInfo({
    String? nickname,
    FileInfo? file,
    List<String>? preferredLanguage,
  });
}

class AuthenticationController extends GetxController implements BaseAuth {
  final SendbirdSdk _sendbird = SendbirdSdk(appId: sendbirdAppId);

  @override
  Future<void> dispose() async {
    logout();
    super.dispose();
  }

  @override
  User? get currentUser => _sendbird.currentUser;

  @override
  bool get isSigned => _sendbird.currentUser != null;

  @override
  Future<User> login({
    required String userId,
    String? nickname,
    String? accessToken,
    String? apiHost,
    String? wsHost,
  }) async {
    try {
      return await _sendbird.connect(
        userId,
        nickname: nickname,
        accessToken: accessToken,
        apiHost: apiHost,
        wsHost: wsHost,
      );
    } catch (e) {
      throw Exception([e, 'Connecting with Sendbird Server has failed']);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _sendbird.disconnect();
    } catch (e) {
      throw Exception([e, 'Disconneting with Sendbird Server has failed']);
    }
  }

  @override
  SendbirdSdk get sendbirdSdk => _sendbird;

  @override
  Future<void> updateCurrentInfo({
    String? nickname,
    FileInfo? file,
    List<String>? preferredLanguage,
  }) async {
    try {
      await _sendbird.updateCurrentUserInfo(
        nickname: nickname,
        fileInfo: file,
        preferredLanguages: preferredLanguage,
      );
    } catch (e) {
      throw Exception([e, 'Failed to update current user info']);
    }
  }
}
