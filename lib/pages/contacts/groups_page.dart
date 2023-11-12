import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
import 'package:qianshi_chat/stores/groups_controller.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _roomsController = Get.find<RoomsController>();
  final _currentUserController = Get.find<CurrentUserController>();

  @override
  Widget build(BuildContext context) {
    return GetX<GroupsController>(
      builder: (controller) => ListView.builder(
        itemCount: controller.groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(
                controller.groups[index].avatar,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(controller.groups[index].name),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var group = controller.groups[index];
              var room = await _roomsController.createRoom(
                  group.id, MessageSendType.group);
              if (room == null) {
                Get.snackbar(
                    Globalization.error.tr, Globalization.errorNetwork);
                return;
              }
              room.avatar = group.avatar;
              room.name = group.name;
              room.fromUser = _currentUserController.current.value;
              room.toObject = group;
              Get.toNamed(RouterContants.chat, arguments: room);
            },
          );
        },
      ),
    );
  }
}
