import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/main_binding.dart';
import 'package:sendbird_flutter/routes/get_page_routes.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SendBird Chat Demo',
      debugShowCheckedModeBanner: false,
      getPages: getPageRoutes,
      initialBinding: MainBinding(),
      initialRoute: MAIN_ROUTE,
    );
  }
}
