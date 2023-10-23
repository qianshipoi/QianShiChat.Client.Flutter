import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: ListView(
          children: [
            _buildUserInfo(context),
            ListTile(
              onTap: () {
                Get.toNamed(RouterContants.settings);
              },
              title: Text(Globalization.settings.tr),
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ));
  }

  GetX<CurrentUserController> _buildUserInfo(BuildContext context) {
    return GetX<CurrentUserController>(builder: (controller) {
      return ListTile(
        onTap: () {},
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                width: 60,
                fit: BoxFit.cover,
                controller.current.value!.avatar,
                errorBuilder: (context, error, stackTrace) {
                  return Text(Globalization.errorNetwork.tr);
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.current.value!.nickName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text("UID:${controller.current.value!.id}"),
              ],
            )),
            const SizedBox(
              width: 16,
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
            const Icon(Icons.keyboard_arrow_right)
          ],
        ),
      );
    });
  }
}
