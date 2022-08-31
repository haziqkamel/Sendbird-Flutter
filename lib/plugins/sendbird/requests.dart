import 'package:sendbird_sdk/sendbird_sdk.dart';

/// Create New Channel based on [ChannelType]
Future<BaseChannel> createChannel({
  required ChannelType channelType,
  required dynamic channelParams,
}) async {
  try {
    switch (channelType) {
      case ChannelType.group:
        final params = channelParams as GroupChannelParams;
        return await GroupChannel.createChannel(params);
      case ChannelType.open:
        final params = channelParams as OpenChannelParams;
        return await OpenChannel.createChannel(params);
    }
  } catch (e) {
    rethrow;
  }
}

/// Edit Channel based on [ChannelType]
Future<void> editChannel(
    {required ChannelType channel, required dynamic channelParams}) async {
  try {
    switch (channel) {
      case ChannelType.group:
        await (channel as GroupChannel)
            .updateChannel(channelParams as GroupChannelParams);
        break;
      case ChannelType.open:
        await (channel as OpenChannel)
            .updateChannel(channelParams as OpenChannelParams);
        break;
    }
  } catch (e) {
    rethrow;
  }
}

Future<void> deleteChannel({required BaseChannel channel}) async {
  try {
    switch (channel.channelType) {
      case ChannelType.group:
        await (channel as GroupChannel).deleteChannel();
        break;
      case ChannelType.open:
        await (channel as OpenChannel).deleteChannel();
        break;
    }
  } catch (e) {
    rethrow;
  }
}

Future<void> leaveChannel({required BaseChannel channel}) async {
  try {
    switch (channel.channelType) {
      case ChannelType.group:
        await (channel as GroupChannel).leave();
        break;
      case ChannelType.open:
        await (channel as OpenChannel).exit();
        break;
    }
  } catch (e) {
    rethrow;
  }
}
