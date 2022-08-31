import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';

import '../root_route.dart';

class LoginRoute extends StatefulWidget {
  final VoidCallback onSignedIn;
  final Examples examples;
  const LoginRoute({
    Key? key,
    required this.onSignedIn,
    required this.examples,
  }) : super(key: key);

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final BaseAuth _authentication = Get.find<AuthenticationController>();
  late TextEditingController _idController;
  String _errorMsg = '';

  @override
  void initState() {
    _idController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Login Route'),
      body: customPadding(
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: 'User ID',
                errorText: _errorMsg == '' ? null : _errorMsg,
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () async {
                try {
                  if (_idController.value.text == '' ||
                      _idController.value.text.isEmpty) {
                    throw Exception('ID cannot be empty');
                  }
                  await _authentication.login(userId: _idController.value.text);

                  switch (widget.examples) {
                    case Examples.main:
                      Get.toNamed(BASIC_EXAMPLE_ROUTE);
                      break;
                    case Examples.features:
                      Get.toNamed(FEATURES_EXAMPLE_ROUTE);
                      break;
                  }
                } on Exception catch (e) {
                  setState(() {
                    _errorMsg = e.toString();
                  });
                } catch (e) {
                  setState(() {
                    _errorMsg = 'Unknown Error: $e';
                  });
                }
              },
              child: const Text(
                'Connect',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
