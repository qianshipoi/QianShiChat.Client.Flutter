import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final roomsController = Get.find<RoomsController>();

  @override
  Widget build(BuildContext context) {
    return GetX<FriendsController>(
        builder: (controller) => _buildListView(context, controller.friends));
  }

  _buildListView(BuildContext context, List<UserInfo> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(
                users[index].avatar,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(users[index].nickName),
            subtitle: _buildOnlineStatus(users[index]),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Get.toNamed(RouterContants.userProfile,
                  arguments: users[index].id);
            },
          );
        });
  }

  Widget _buildOnlineStatus(UserInfo user) {
    if (user.isOnline) {
      return const Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.green,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text('在线'),
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(Icons.circle, color: Colors.grey, size: 14),
          SizedBox(
            width: 4,
          ),
          Text('离线'),
        ],
      );
    }
  }
}
