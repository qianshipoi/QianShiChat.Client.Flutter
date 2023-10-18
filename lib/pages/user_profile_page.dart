import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';
import 'package:qianshi_chat/stores/users_controller.dart';

import '../stores/current_user_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final usersController = Get.find<UsersController>();
  final friendsController = Get.find<FriendsController>();
  final roomsController = Get.find<RoomsController>();
  final currentUserController = Get.find<CurrentUserController>();
  final int userId = Get.arguments;

  Future<UserInfo> _getUserInfo() async {
    var userInfo = await usersController.getUserById(userId);
    if (userInfo == null) throw Exception('用户不存在');
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户资料'),
      ),
      body: FutureBuilder<UserInfo>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(snapshot.data!.avatar),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.nickName),
                        Text(snapshot.data!.account),
                      ],
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomCenter,
                  child: _buildActions(snapshot.data!),
                )),
              ],
            );
          }),
    );
  }

  Widget _buildActions(UserInfo user) {
    if (currentUserController.current.value?.id == user.id) {
      return const SizedBox();
    }

    if (friendsController.isFriend(user)) {
      return ElevatedButton(
          onPressed: () async {
            var room = await roomsController.createRoom(
                user.id, MessageSendType.personal);
            if (room == null) {
              Get.snackbar('提示', '创建房间失败');
              return;
            }
            room.fromUser = currentUserController.current.value;
            room.toObject = user;
            Get.toNamed('/chat', arguments: room);
          },
          child: const Text('发消息'));
    } else {
      return ElevatedButton(onPressed: () {}, child: const Text('加好友'));
    }
  }
}
