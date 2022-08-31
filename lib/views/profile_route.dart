import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_flutter/controllers/authentication/authentication_controller.dart';
import 'package:sendbird_flutter/plugins/sendbird/user_request.dart';
import 'package:sendbird_flutter/routes/route_path.dart';
import 'package:sendbird_flutter/widgets/custom_appbar.dart';
import 'package:sendbird_flutter/widgets/custom_dialog.dart';
import 'package:sendbird_flutter/widgets/custom_padding.dart';

class ProfileRoute extends StatefulWidget {
  const ProfileRoute({Key? key}) : super(key: key);

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  late final BaseAuth _authentication = Get.find<AuthenticationController>();
  late final TextEditingController _nameController;
  late final TextEditingController _fileUrlController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    _nameController = TextEditingController();
    _fileUrlController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  Widget _nameWidget() {
    if (_authentication.currentUser?.nickname != null) {
      return Text(
        'Hello, ${_authentication.currentUser?.nickname.capitalizeFirst}',
        style: const TextStyle(fontSize: 24),
      );
    } else {
      return const Text(
        'Hello!',
        style: TextStyle(fontSize: 24),
      );
    }
  }

  Future<void> uploadImageProfile() async {
    try {
      final profileImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (profileImage != null) {
        print(profileImage.path);
        await updateUserInfo(file: File(profileImage.path));
        printInfo(info: 'User profile image successfully updated!');
        if (mounted) {
          customDialog(
            context,
            title: 'Profile Image has been updated!',
            type: DialogType.oneButton,
          );
        }
        setState(() {});
      }
    } catch (e) {
      customDialog(
        context,
        title: 'Error!',
        content:
            'Unable to update image profile, please try profileUrl instead. This is probably due to plugin availability',
        buttonText1: 'OK',
        type: DialogType.oneButton,
      );
      printError(info: 'Upload image profile failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'My Profile',
        includeLeading: false,
      ),
      body: SingleChildScrollView(
        child: customPadding(
          horizontalPadding: 40,
          verticalPadding: 50,
          widget: Column(
            children: [
              _nameWidget(),
              const SizedBox(height: 20),
              _authentication.currentUser?.profileUrl != null &&
                      _authentication.currentUser?.profileUrl != ''
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        _authentication.currentUser!.profileUrl!,
                      ),
                      child: SizedBox.expand(
                        child: IconButton(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(4),
                          onPressed: () async {
                            await uploadImageProfile();
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 40,
                      child: IconButton(
                        onPressed: () async {
                          await uploadImageProfile();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
              const SizedBox(height: 25),
              TextField(
                controller: _fileUrlController,
                decoration: const InputDecoration(
                  hintText: 'Profile File Url',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Change Nickname',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  try {
                    await updateUserInfo(
                      nickName: _nameController.value.text,
                      fileUrl: _fileUrlController.value.text,
                    );
                    setState(() {});

                    if (!mounted) {
                      return;
                    }
                    _nameController.clear();
                    _fileUrlController.clear();
                    FocusScope.of(context).unfocus();
                    customDialog(
                      context,
                      title: 'Info',
                      content: 'User Info has changed',
                      buttonText1: 'OK',
                      type: DialogType.oneButton,
                    );
                  } catch (e) {
                    printError(info: e.toString());
                  }
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () async {
                  try {
                    await _authentication.logout();
                    Get.offAllNamed(MAIN_ROUTE);
                  } catch (e) {
                    printError(info: e.toString());
                  }
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
