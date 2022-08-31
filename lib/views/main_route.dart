import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/views/root_route.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: customPadding(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed(
                  ROOT_ROUTE,
                  arguments: Examples.main, //refactor pull out the enums
                );
              },
              child: const Text(
                'Main Example',
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Get.toNamed(ROOTROUTE);
              },
              child: const Text(
                'Features Example',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
