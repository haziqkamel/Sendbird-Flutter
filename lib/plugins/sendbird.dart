import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class Sendbird {
  static const sendbirdAppId = "E1B4C3EC-AF1F-4888-9237-11223F1137D8";

  static final sendbird = SendbirdSdk(appId: sendbirdAppId);

  late User user;
  // OpenChannel that is opened with openChannel method
  late OpenChannel _currentChannel;
  OpenChannel get currentChannel => _currentChannel;

  // Connect to sendbird server
  // The USER_ID should be unique to your sendbird application.
  init({required String userId}) async {
    try {
      user = await sendbird.connect(userId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Create a new open channel
  // Create an open channel using the following codes. Open channels are where all users in your Sendbird application easily participate without an invitation.
  Future<void> openChannel(
      {required String name,
      String? data,
      required List<String> operatorUserIds,
      String? url}) async {
    try {
      // Open Channel Params
      final params = OpenChannelParams()
        ..name = name
        ..data = data
        ..operatorUserIds = operatorUserIds
        ..customType = null
        ..coverImage = FileInfo.fromUrl(url: url);

      // Cover image can also take image files
      _currentChannel = await OpenChannel.createChannel(params);
      // An open channel is successfully created.
      // Through the `openChannel` parameter of the callback method, you can get the open channel's data from the result object that Sendbird server has passed.
      print("OpenChannel URL: ${_currentChannel.channelUrl}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Enter a channel
  Future<bool> enterChannel({required String? channelUrl}) async {
    try {
      if (channelUrl != null) {
        final channel = await retrieveChannelByUrl(channelUrl: channelUrl);
        await channel.enter();
        return true;
      } else {
        _currentChannel.enter();
        return true;
      }
    } on SBError catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  // Exit a channel
  void exitChannel({required String? channelUrl}) async {
    try {
      if (channelUrl != null) {
        final channel = await retrieveChannelByUrl(channelUrl: channelUrl);
        await channel.exit();
      } else {
        _currentChannel.exit();
      }
    } on SBError catch (e) {
      debugPrint(e.message);
    }
  }

  // Delete a channel
  void deleteChannel({required String? channelUrl}) async {
    try {
      if (channelUrl != null) {
        final channel = await retrieveChannelByUrl(channelUrl: channelUrl);
        await channel.deleteChannel();
      } else {
        _currentChannel.deleteChannel();
      }
    } on SBError catch (e) {
      debugPrint(e.message);
    }
  }

  // Retrieve list of channels
  Future<List<OpenChannel>?> getAllChannels(
      {required String channelUrl}) async {
    List<OpenChannel> listOfOpenChannel = [];

    try {
      final channel = await retrieveChannelByUrl(channelUrl: channelUrl);
      final OpenChannelListQuery listQuery = OpenChannelListQuery()
        ..channelUrl = channel.channelUrl;
      listOfOpenChannel = await listQuery.loadNext();
      // A list of open channels is successfully retrieved.
      // Through the `openChannel` parameter of the callback method, you can access the data
      // of each open channel from the result list that Sendbird server has passed.
      return listOfOpenChannel;
    } on SBError catch (e) {
      debugPrint(e.message);
      return listOfOpenChannel;
    }
  }

  Future<OpenChannel> retrieveChannelByUrl({required String channelUrl}) async {
    OpenChannel channel = OpenChannel(
        participantCount: 0, operators: [user], channelUrl: channelUrl);
    try {
      channel = await OpenChannel.getChannel(channelUrl);
      // Through the `openChannel` parameter of the callback method, Sendbird server returns
      // the open channel object identified with the `CHANNEL_URL`.
      // You can also get the open channel's data from the result object.
      return channel;
    } on SBError catch (e) {
      debugPrint(e.message);
      return channel;
    }
  }

  sendMessage({required UserMessageParams? params}) {
    if (params != null) {
      currentChannel.sendUserMessage(
        params,
        onCompleted: (message, error) {
          if (error != null) {
            print(error.toString());
          } else {
            print(message.toString());
          }
        },
      );
    } else {}
  }
}

final sendBird = Sendbird();
