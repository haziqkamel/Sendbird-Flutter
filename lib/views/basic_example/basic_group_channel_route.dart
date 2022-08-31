import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/plugins/sendbird/requests.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_dialog.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';

class BasicGroupChannelRoute extends StatefulWidget {
  const BasicGroupChannelRoute({Key? key}) : super(key: key);

  @override
  State<BasicGroupChannelRoute> createState() => _BasicGroupChannelRouteState();
}

class _BasicGroupChannelRouteState extends State<BasicGroupChannelRoute> {
  final BaseAuth _authentication = Get.find<AuthenticationController>();
  late List<GroupChannel> _groupChannelList;

  @override
  void initState() {
    // _groupChannelList = await loadGroupChannelList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<List<GroupChannel>> loadGroupChannelList() async {
    try {
      return await GroupChannelListQuery().loadNext();
    } catch (e) {
      throw Exception([e, 'Error retrieving Group Channel List']);
    }
  }

  Widget getGroupChannelIcon(GroupChannel? groupChannel) {
    if (groupChannel != null) {
      if (groupChannel.coverUrl != null && groupChannel.coverUrl != '') {
        return SizedBox.square(
          dimension: 60,
          child: Image.network(groupChannel.coverUrl!),
        );
      }
    }
    return const Icon(Icons.message);
  }

  Widget _infoButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(PROFILE_ROUTE)?.then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.person),
      ),
    );
  }

  Future<void> refresh() async {
    await loadGroupChannelList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(CREATE_CHANNEL_ROUTE, arguments: [ChannelType.group])
              ?.then((_) {
            setState(() {});
          });
        },
        backgroundColor: Colors.pinkAccent[800],
        child: const Icon(Icons.add),
      ),
      appBar: customAppBar(
          title: 'Group Channel Route',
          includeLeading: false,
          actions: [_infoButton()]),
      body: LiquidPullToRefresh(
        onRefresh: () => refresh(),
        child: SingleChildScrollView(
          child: FutureBuilder<List<GroupChannel>>(
            future: loadGroupChannelList(),
            builder: (context, groupChannelList) {
              if (groupChannelList.hasData) {
                return ListView.builder(
                  itemCount: groupChannelList.data?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: getGroupChannelIcon(groupChannelList.data?[i]),
                      trailing: GestureDetector(
                        onTap: () => customDialog(context,
                            title: 'Are you sure to delete this group?',
                            content:
                                'Deleting this group will permanently remove group from server',
                            buttonText1: 'Delete',
                            type: DialogType.oneButton, onTap1: () async {
                          await deleteChannel(
                            channel: groupChannelList.data![i],
                          ).then((_) async {
                            await loadGroupChannelList();
                            setState(() {});
                          });
                        }),
                        child: const Icon(Icons.edit),
                      ),
                      title: Text(groupChannelList.data?[i].name ?? 'No Name'),
                      subtitle: Text(
                        groupChannelList.data?[i].lastMessage?.message ?? '',
                      ),
                      onTap: () {
                        Get.toNamed(CHAT_ROOM_ROUTE, arguments: [
                          ChannelType.group
                        ], parameters: {
                          'channelUrl':
                              groupChannelList.data?[i].channelUrl ?? ''
                        })?.then((_) {
                          setState(() {});
                        });
                      },
                    );
                  },
                );
              } else if (groupChannelList.hasError) {
                return const Text('Error Retrieving Group Channel');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
