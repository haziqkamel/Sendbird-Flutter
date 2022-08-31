import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/views/basic_example/basic_example_route.dart';

import 'features_example/features_example_route.dart';
import 'login/login_route.dart';

enum AuthStatus { notSignedIn, signedIn }

enum Examples { main, features }

class RootRoute extends StatefulWidget {
  const RootRoute({Key? key}) : super(key: key);

  @override
  State<RootRoute> createState() => _RootRouteState();
}

class _RootRouteState extends State<RootRoute> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  late BaseAuth _authentication;
  late bool _isSigned;
  late Examples _examples;

  @override
  void initState() {
    _authentication = AuthenticationController();
    _isSigned = _authentication.isSigned;
    _authStatus =
        _isSigned == true ? AuthStatus.signedIn : AuthStatus.notSignedIn;
    _examples = Get.arguments as Examples;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _authentication.dispose();
    super.dispose();
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginRoute(onSignedIn: _signedIn, examples: _examples);
      case AuthStatus.signedIn:
        switch (_examples) {
          case Examples.main:
            return BasicExampleRoute();
          case Examples.features:
            return const FeaturesExampleRoute();
        }
    }
  }
}
