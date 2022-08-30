import 'package:flutter/material.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/views/channel_page.dart';
import 'package:sendbird_flutter/views/homepage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME:
        return MaterialPageRoute(
          builder: (_) => MyHomePage(),
          settings: const RouteSettings(name: HOME),
        );
      case CHANNELPAGE:
        return MaterialPageRoute(
          builder: (_) => const ChannelPage(),
          settings: const RouteSettings(name: CHANNELPAGE),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
