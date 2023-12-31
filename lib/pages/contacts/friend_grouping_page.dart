import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';
import 'package:qianshi_chat/widget/user_tile.dart';

class FriendGroupingPage extends StatefulWidget {
  const FriendGroupingPage({super.key});

  @override
  State<FriendGroupingPage> createState() => _FriendGroupingPageState();
}

class _FriendGroupingPageState extends State<FriendGroupingPage> {
  @override
  Widget build(BuildContext context) {
    return GetX<FriendsController>(builder: (controller) {
      return ListView.builder(
        itemCount: controller.groups.length,
        itemBuilder: (context, index) {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: PageStorageKey(controller.groups[0].value.id),
              title: GestureDetector(
                  onLongPress: () =>
                      Get.toNamed(RouterContants.friendGroupManage),
                  child: Obx(() => Row(
                        children: [
                          Text(controller.groups[index].value.name.value),
                          Text(
                            '(${controller.groups[index].value.friends.length})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ))),
              maintainState: true,
              children: [
                _buildListView(context, controller.groups[index].value.friends),
              ],
            ),
          );
        },
      );
    });
  }

  _buildListView(BuildContext context, RxList<UserInfo> friends) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return UserTitl(
            user: friends[index],
          );
        });
  }
}
