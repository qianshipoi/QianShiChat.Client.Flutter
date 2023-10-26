import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/user_provider.dart';

class ApplyFriendPage extends StatefulWidget {
  const ApplyFriendPage({super.key});

  @override
  State<ApplyFriendPage> createState() => _ApplyFriendPageState();
}

class _ApplyFriendPageState extends State<ApplyFriendPage> {
  final UserInfo _user = Get.arguments;
  final TextEditingController _remarkController = TextEditingController();
  final UserProvider _userProvider = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globalization.applyFriendPageTitle.tr),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                // avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(_user.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(_user.nickName),
                    Text("UID:${_user.id}"),
                  ],
                )
              ],
            ),
            Text(Globalization.remark.tr),
            TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Globalization.remark.tr,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var response = await _userProvider.friendApply(
                          _user.id, _remarkController.text);
                      if (response.hasError) {
                        Get.snackbar(Globalization.error.tr,
                            Globalization.errorNetwork.tr);
                        return;
                      }
                      if (!response.body!.succeeded) {
                        Get.snackbar(
                            Globalization.error.tr, response.body!.errors);
                        return;
                      }
                      Get.snackbar(Globalization.success.tr,
                          Globalization.applySuccess.tr);
                      Get.back();
                    },
                    child: Text(Globalization.actionApply.tr)),
                ElevatedButton(
                  onPressed: Get.back,
                  child: Text(Globalization.actionCancel.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
