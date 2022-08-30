import 'package:get/get.dart';
import 'package:sendbird_flutter/plugins/sendbird.dart';
import 'package:sendbird_flutter/views/channel_page.dart';

class HomePageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    sendBird.init(userId: "1");
  }

  RxString channelUrl = "".obs;

  initSendBird() => sendBird.init(userId: "1");

  createNewOpenChannel() async {
    await sendBird.openChannel(
        name: "New Channel", operatorUserIds: [sendBird.user.userId]).then((_) {
      channelUrl.value = sendBird.currentChannel.channelUrl;
    });
  }

  void enterChannel() async {
    await sendBird.enterChannel(channelUrl: channelUrl.value).then(
      (shouldNavigate) {
        if (shouldNavigate) {
          Get.to(const ChannelPage());
        } else {
          print("Something went wrong!");
        }
      },
    );
  }
}
