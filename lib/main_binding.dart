import 'package:get/get.dart';

import 'controllers/authentication/authentication_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController(), permanent: true);
  }
}
