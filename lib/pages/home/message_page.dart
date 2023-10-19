import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final roomsController = Get.find<RoomsController>();

  String _timestampToTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var now = DateTime.now();
    var diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${date.month}-${date.day}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  String _formatContent(dynamic content) {
    if (content is String) {
      return content;
    } else if (content is Map) {
      return '[${content['type']}]';
    } else {
      return '';
    }
  }

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
                  title: Text(room.name ?? ""),
                  subtitle: Text(_formatContent(room.lastMessageContent)),
                  trailing: Text(_timestampToTime(room.lastMessageTime)),
                  onTap: () {
                    Get.toNamed('/chat', arguments: room);
                  },
                );
              },
            )));
  }
}
