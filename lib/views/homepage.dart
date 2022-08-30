import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/homepage_controller.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final HomePageController _controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SendBird Chat Demo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Obx(
                () => Text(
                  _controller.channelUrl.string,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Obx(
                () => _controller.channelUrl.value != ""
                    ? ElevatedButton(
                        onPressed: _controller.enterChannel,
                        child: const Text("Enter Channel"),
                      )
                    : ElevatedButton(
                        onPressed: _controller.createNewOpenChannel,
                        child: const Text('Create A Channel'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
