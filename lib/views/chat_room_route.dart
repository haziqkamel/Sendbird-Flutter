import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/handlers/channel_event_handlers.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_dialog.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';
import 'package:sendbird_flutter/widgets/message_field_widget.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatRoomRoute extends StatefulWidget {
  const ChatRoomRoute({Key? key}) : super(key: key);

  @override
  State<ChatRoomRoute> createState() => _ChatRoomRouteState();
}

class _ChatRoomRouteState extends State<ChatRoomRoute> {
  final BaseAuth _authentication = Get.find<AuthenticationController>();
  final String? _channelUrl = Get.parameters['channelUrl'];
  final ChannelType _channelType = Get.arguments[0];
  late final ScrollController _scrollController;
  late final TextEditingController _messageController;
  BaseChannel? _channel;
  late Future<BaseChannel> _futureChannel;
  late final ChannelEventHandlers _channelEventHandlers;

  @override
  void initState() {
    _scrollController = ScrollController();
    _messageController = TextEditingController();

    _channelEventHandlers = ChannelEventHandlers(
      refresh: refresh,
      channelUrl: _channelUrl!,
      channelType: _channelType,
    );

    _futureChannel = _channelEventHandlers
        .getChannel(_channelUrl!, channelType: _channelType)
        .then((channel) {
      _channelEventHandlers.loadMessages(isForce: true);

      if (channel is GroupChannel) {
        channel.markAsRead();
      }

      _channel = channel;
      return channel;
    });
    _scrollToBottom();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_channel is GroupChannel) {
      (_channel as GroupChannel).markAsRead();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _channelEventHandlers.dispose();
    super.dispose();
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      print('scroll has client');
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      print('scroll no client');
    }
  }

  Future<void> refresh({
    bool loadPrevious = false,
    bool isForce = false,
  }) async {
    switch (_channelType) {
      case ChannelType.group:
        _channel ??= await GroupChannel.getChannel(_channelUrl!);
        break;
      case ChannelType.open:
        _channel ??= await OpenChannel.getChannel(_channelUrl!);
        break;
    }

    if (mounted) {
      if (loadPrevious) {
        _channelEventHandlers.loadMessages();
      } else if (isForce) {
        _channelEventHandlers.loadMessages(isForce: true);
      }
    }
    setState(() {});
  }

  Future<void> messageSent() async {
    _scrollToBottom();
    await refresh(isForce: true);
  }

  Widget _infoButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/ChatDetailRoute', arguments: [_channel])?.then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureChannel,
      builder: (context, AsyncSnapshot<BaseChannel> messages) {
        if (messages.hasData) {
          return Scaffold(
            appBar: customAppBar(
              title: 'Chat Room',
              includeLeading: false,
              actions: [_infoButton()],
            ),
            bottomNavigationBar: MessageFieldWidget(
              controller: _messageController,
              channel: _channel!,
              onSend: messageSent,
            ),
            body: LiquidPullToRefresh(
              onRefresh: () => refresh(loadPrevious: true),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: customPadding(
                  widget: ListView.builder(
                    itemCount: _channelEventHandlers.messages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      // if (_channelEventHandlers.messages[i]
                      //     is UserMessage) {
                      //   final m = _channelEventHandlers.messages[i]
                      //       as UserMessage;
                      //   print('UserMessage: ${m.message}');
                      // } else if (_channelEventHandlers.messages[i]
                      //     is FileMessage) {
                      //   final m = _channelEventHandlers.messages[i]
                      //       as FileMessage;
                      //   print('FileMessage: ${m.message}');
                      // } else {
                      //   final m = _channelEventHandlers.messages[i]
                      //       as AdminMessage;
                      //   print('AdminMessage: ${m.message}');
                      // }
                      Widget? titleWidget;
                      if (_channelEventHandlers.messages[i] is UserMessage) {
                        titleWidget = Text(
                          _channelEventHandlers.messages[i].message,
                          textAlign: _channelEventHandlers
                                      .messages[i].sender?.userId ==
                                  _authentication.currentUser?.userId
                              ? TextAlign.right
                              : TextAlign.left,
                        );
                      } else if (_channelEventHandlers.messages[i]
                          is FileMessage) {
                        titleWidget = Row(
                          mainAxisAlignment: _channelEventHandlers
                                      .messages[i].sender?.userId ==
                                  _authentication.currentUser?.userId
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: (_channelEventHandlers.messages[i]
                                              as FileMessage)
                                          .secureUrl ??
                                      (_channelEventHandlers.messages[i]
                                              as FileMessage)
                                          .url,
                                  placeholder: (context, url) => const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(_channelEventHandlers.messages[i].message),
                              ],
                            ),
                          ],
                        );
                      } else if (_channelEventHandlers.messages[i]
                          is AdminMessage) {
                        titleWidget = Text(
                          'Admin: ${_channelEventHandlers.messages[i].message}',
                          textAlign: _channelEventHandlers
                                      .messages[i].sender?.userId ==
                                  _authentication.currentUser?.userId
                              ? TextAlign.right
                              : TextAlign.left,
                        );
                      } else {
                        printError(info: 'Unknown Message Type');
                      }

                      return ListTile(
                        isThreeLine: false,
                        leading:
                            _channelEventHandlers.messages[i].sender?.userId ==
                                    _authentication.currentUser?.userId
                                ? null
                                : const Icon(Icons.person),
                        trailing:
                            _channelEventHandlers.messages[i].sender?.userId ==
                                    _authentication.currentUser?.userId
                                ? const Icon(Icons.person)
                                : null,
                        title: titleWidget,
                        subtitle: _channel!.channelType == ChannelType.group
                            ? Text(
                                'Unread ${(_channel as GroupChannel).getUnreadMembers(_channelEventHandlers.messages[i]).length}',
                                textAlign: _channelEventHandlers
                                            .messages[i].sender?.userId ==
                                        _authentication.currentUser?.userId
                                    ? TextAlign.right
                                    : TextAlign.left,
                              )
                            : null,
                        onLongPress: () {
                          if (_channelEventHandlers.messages[i]
                              is UserMessage) {
                            customDialog(
                              context,
                              type: DialogType.twoButton,
                              buttonText1: 'Edit',
                              onTap1: () async {
                                // TODO: Edit user message
                                refresh();
                              },
                              buttonText2: 'Delete',
                              onTap2: () async {
                                //TODO: Delete user message
                                refresh();
                              },
                            );
                          } else if (_channelEventHandlers.messages[i]
                              is FileMessage) {
                            customDialog(context,
                                type: DialogType.oneButton,
                                buttonText1: 'Delete', onTap1: () async {
                              //TODO: Delete File Message
                              refresh();
                            });
                          } else {
                            printError(info: 'Unknown Message Type');
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else if (messages.hasError) {
          return const Center(
            child: Text('Error retrieving messages'),
          );
        } else {
          return Scaffold(
            appBar: customAppBar(title: 'Chat Room', includeLeading: false),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
