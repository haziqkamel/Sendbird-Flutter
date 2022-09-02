import 'package:get/get.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/views/basic_example/basic_create_channel_route.dart';
import 'package:sendbird_flutter/views/basic_example/basic_example_route.dart';
import 'package:sendbird_flutter/views/basic_example/basic_group_channel_route.dart';
import 'package:sendbird_flutter/views/basic_example/basic_open_channel_route.dart';
import 'package:sendbird_flutter/views/chat_room_route.dart';
import 'package:sendbird_flutter/views/features_example/features_example_route.dart';
import 'package:sendbird_flutter/views/main_route.dart';
import 'package:sendbird_flutter/views/profile_route.dart';
import 'package:sendbird_flutter/views/root_route.dart';

final List<GetPage> getPageRoutes = [
  GetPage(name: MAIN_ROUTE, page: () => const MainRoute()),
  GetPage(name: ROOT_ROUTE, page: () => const RootRoute()),
  GetPage(name: BASIC_EXAMPLE_ROUTE, page: () => BasicExampleRoute()),
  GetPage(
      name: FEATURES_EXAMPLE_ROUTE, page: () => const FeaturesExampleRoute()),
  GetPage(
      name: BASIC_GROUP_CHANNEL_ROUTE,
      page: () => const BasicGroupChannelRoute()),
  GetPage(
      name: BASIC_OPEN_CHANNEL_ROUTE,
      page: () => const BasicOpenChannelRoute()),
  GetPage(name: CREATE_CHANNEL_ROUTE, page: () => const CreateChannelRoute()),
  GetPage(name: PROFILE_ROUTE, page: () => const ProfileRoute()),
  GetPage(name: CHAT_ROOM_ROUTE, page: () => const ChatRoomRoute()),
];
