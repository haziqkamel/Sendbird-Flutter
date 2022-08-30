import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/routes/route_generator.dart';
import 'package:sendbird_flutter/routes/route_path.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
  }, (e, trace) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: trace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SendBird Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: HOME,
    );
  }
}
