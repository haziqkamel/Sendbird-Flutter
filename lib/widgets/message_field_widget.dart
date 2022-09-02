import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_flutter/widgets/custom_dialog.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/params/file_message_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';

class MessageFieldWidget extends StatelessWidget {
  const MessageFieldWidget(
      {Key? key,
      required this.controller,
      required this.channel,
      required this.onSend})
      : super(key: key);

  final TextEditingController controller;
  final BaseChannel channel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    File? file;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: Row(
        children: [
          IconButton(
            onPressed: () => customDialog(
              context,
              title: 'File Upload',
              content: 'Choose type to upload',
              buttonText1: 'Image',
              onTap1: () async {
                try {
                  final xfile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (xfile == null) {
                    throw Exception('File not chosen');
                  }
                  file = File(xfile.path);
                } catch (e) {
                  throw Exception('File Message Send Failed');
                }
                controller.clear();
              },
              buttonText2: 'Video',
              onTap2: () async {
                try {
                  final xfile =
                      await picker.pickVideo(source: ImageSource.gallery);
                  if (xfile == null) {
                    throw Exception('File not chosen');
                  }
                  file = File(xfile.path);
                } catch (e) {
                  throw Exception('File Message Send Failed');
                }
                controller.clear();
              },
            ),
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: controller,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          IconButton(
            onPressed: () {
              if (file != null) {
                channel.sendFileMessage(
                  FileMessageParams.withFile(file!),
                  onCompleted: (message, error) => {
                    file = null,
                    controller.clear(),
                    onSend(),
                  },
                );
              } else if (controller.value.text.isNotEmpty) {
                channel.sendUserMessage(
                  UserMessageParams(message: controller.value.text),
                  onCompleted: ((message, error) => {
                        controller.clear(),
                        onSend(),
                      }),
                );
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
