import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/plugins/sendbird/channel_request.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class CreateChannelRoute extends StatefulWidget {
  const CreateChannelRoute({Key? key}) : super(key: key);

  @override
  State<CreateChannelRoute> createState() => _CreateChannelRouteState();
}

class _CreateChannelRouteState extends State<CreateChannelRoute> {
  final BaseAuth _authentication = Get.find<AuthenticationController>();
  final ChannelType _channelType = Get.arguments[0];
  late final TextEditingController _channelNameController;
  late final TextEditingController _inviteIdController;
  final List<String> _inviteIds = [];

  @override
  void initState() {
    _channelNameController = TextEditingController();
    _inviteIdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _channelNameController.dispose();
    _inviteIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title:
            'Create ${_channelType == ChannelType.group ? 'Group' : 'Open'} Channel',
        includeLeading: false,
      ),
      body: SingleChildScrollView(
        child: customPadding(
          widget: Column(
            children: [
              const SizedBox(height: 60),
              if (_inviteIds.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.circular(10)),
                  height: 150,
                  child: ListView.builder(
                    itemCount: _inviteIds.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          _inviteIds.removeAt(i);
                          setState(() {});
                        },
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(_inviteIds[i]),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 35),
              TextField(
                controller: _channelNameController,
                decoration: const InputDecoration(
                  hintText: 'Channel Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _channelType == ChannelType.group
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inviteIdController,
                            decoration: const InputDecoration(
                              hintText: 'Invite UserId',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_inviteIdController.value.text.isEmpty) {
                              return;
                            }
                            _inviteIds.add(_inviteIdController.value.text);
                            _inviteIdController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (_channelNameController.text.isEmpty) {
                    return;
                  }

                  dynamic params;
                  switch (_channelType) {
                    case ChannelType.group:
                      params = GroupChannelParams()
                        ..name = _channelNameController.value.text
                        ..operatorUserIds = [
                          _authentication.currentUser!.userId
                        ]
                        ..userIds = _inviteIds;
                      break;
                    case ChannelType.open:
                      params = OpenChannelParams()
                        ..name = _channelNameController.text
                        ..operatorUserIds = [
                          _authentication.currentUser!.userId
                        ];
                      break;
                  }
                  await createChannel(
                      channelType: _channelType, channelParams: params);
                  Get.back();
                },
                child: Text(
                  'Create ${_channelType == ChannelType.group ? 'Group' : 'Open'} Channel',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
