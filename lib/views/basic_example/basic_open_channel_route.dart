import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/plugins/sendbird/channel_request.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_dialog.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class BasicOpenChannelRoute extends StatefulWidget {
  const BasicOpenChannelRoute({Key? key}) : super(key: key);

  @override
  State<BasicOpenChannelRoute> createState() => _BasicOpenChannelRouteState();
}

class _BasicOpenChannelRouteState extends State<BasicOpenChannelRoute> {
  // ignore: unused_field
  final BaseAuth _authentication = Get.find<AuthenticationController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<List<OpenChannel>> loadOpenChannelList() async {
    try {
      return await OpenChannelListQuery().loadNext();
    } catch (e) {
      throw Exception([e, 'Error retrieving Open Channel List']);
    }
  }

  Widget getOpenChannelIcon(OpenChannel? openChannel) {
    if (openChannel != null) {
      if (openChannel.coverUrl != null && openChannel.coverUrl != '') {
        return SizedBox.square(
          dimension: 60,
          child: Image.network(openChannel.coverUrl!),
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

  Widget _deleteOpenChannel(
      AsyncSnapshot<List<OpenChannel>> openChannelList, int i) {
    return GestureDetector(
      onTap: () => customDialog(context,
          title: 'Are you sure to delete this channel?',
          content:
              'Deleting this channel will permanently remove selected channel from server',
          buttonText1: 'Delete',
          type: DialogType.oneButton, onTap1: () async {
        await deleteChannel(
          channel: openChannelList.data![i],
        ).then((_) async {
          await loadOpenChannelList();
          setState(() {});
        });
      }),
      child: const Icon(Icons.edit),
    );
  }

  Future<void> _joinOpenChannel(OpenChannel channel) async {
    customDialog(
      context,
      title: 'Join Channel',
      content: 'Would you like to join the channel?',
      buttonText1: 'Yes',
      buttonText2: 'Cancel',
      type: DialogType.twoButton,
      onTap1: () async => await channel.enter(),
      onTap2: () => Navigator.canPop(context),
    );
  }

  Future<void> refresh() async {
    await loadOpenChannelList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(CREATE_CHANNEL_ROUTE, arguments: [ChannelType.open])
              ?.then((_) {
            setState(() {});
          });
        },
        splashColor: Colors.pink,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
      appBar: customAppBar(
          title: 'Open Channel Route',
          includeLeading: false,
          actions: [_infoButton()]),
      body: LiquidPullToRefresh(
        onRefresh: () => refresh(),
        child: SingleChildScrollView(
          child: FutureBuilder<List<OpenChannel>>(
            future: loadOpenChannelList(),
            builder: (context, openChannelList) {
              if (openChannelList.hasData) {
                return ListView.builder(
                  itemCount: openChannelList.data?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: getOpenChannelIcon(openChannelList.data![i]),
                      trailing: openChannelList.data![i]
                              .isOperator(_authentication.currentUser!.userId)
                          ? null
                          : _deleteOpenChannel(openChannelList, i),
                      title: Text(openChannelList.data?[i].name ?? 'No Name'),
                      subtitle: Text(
                        'Number of participant: ${openChannelList.data?[i].participantCount.toString() ?? ''}',
                      ),
                      onTap: () async {
                        if (openChannelList.data![i].entered) {
                          Get.toNamed(CHAT_ROOM_ROUTE, arguments: [
                            ChannelType.group
                          ], parameters: {
                            'channelUrl':
                                openChannelList.data?[i].channelUrl ?? ''
                          })?.then((_) {
                            setState(() {});
                          });
                        } else {
                          await _joinOpenChannel(openChannelList.data![i])
                              .then((_) {
                            Get.toNamed(CHAT_ROOM_ROUTE, arguments: [
                              ChannelType.group
                            ], parameters: {
                              'channelUrl':
                                  openChannelList.data?[i].channelUrl ?? ''
                            })?.then((_) {
                              setState(() {});
                            });
                          });
                        }
                      },
                    );
                  },
                );
              } else if (openChannelList.hasError) {
                return const Text('Error Retrieving Open Channel');
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
