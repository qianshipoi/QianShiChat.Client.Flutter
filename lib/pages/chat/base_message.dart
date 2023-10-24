import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/userinfo.dart';

abstract class BaseMessage extends StatelessWidget {
  final bool isMe;
  final UserInfo user;
  final Message message;
  const BaseMessage({
    super.key,
    required this.isMe,
    required this.user,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe)
          GestureDetector(
            onTap: () {
              Get.toNamed(RouterContants.userProfile, arguments: user.id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
          ),
        Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 96,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(8)),
            child: buildChild(context, message, isMe, user)),
        if (isMe)
          GestureDetector(
            onTap: () {
              Get.toNamed(RouterContants.userProfile, arguments: user.id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
          ),
      ],
    );
  }

  @protected
  Widget buildChild(
      BuildContext context, Message message, bool isMe, UserInfo user);
}
