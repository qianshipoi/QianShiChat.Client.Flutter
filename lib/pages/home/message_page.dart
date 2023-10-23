import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';
import 'package:qianshi_chat/utils/common_util.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final roomsController = Get.find<RoomsController>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Obx(() => ListView.builder(
              itemCount: roomsController.rooms.length,
              itemBuilder: (context, index) {
                var room = roomsController.rooms[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      room.avatar!,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(room.name!),
                  subtitle: Text(
                      CommonUtil.formatMessageContent(room.lastMessageContent)),
                  trailing:
                      Text(CommonUtil.timestampToTime(room.lastMessageTime)),
                  onTap: () {
                    Get.toNamed(RouterContants.chat, arguments: room);
                  },
                );
              },
            )));
  }
}
