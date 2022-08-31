import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';

class BasicExampleRoute extends StatelessWidget {
  BasicExampleRoute({Key? key}) : super(key: key);

  final BaseAuth _authentication = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Main Example Page'),
      body: SingleChildScrollView(
        child: customPadding(
          widget: Column(
            children: [
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(BASIC_GROUP_CHANNEL_ROUTE),
                child: const Text(
                  'Group Channel Example',
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Get.toNamed(OPENCHANNELROUTE);
                },
                child: const Text(
                  'Open Channel Example',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
