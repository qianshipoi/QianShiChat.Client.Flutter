import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/chat/base_message.dart';

class VideoMessage extends BaseMessage {
  const VideoMessage(
      {super.key,
      required super.isMe,
      required super.user,
      required super.message});

  @override
  Widget buildChild(
      BuildContext context, Message message, bool isMe, UserInfo user) {
    return const Text('Video');
  }
}
