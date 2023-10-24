import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/chat/base_message.dart';
import 'package:qianshi_chat/pages/photo_view_page.dart';

class ImageMessage extends BaseMessage {
  const ImageMessage(
      {super.key,
      required super.isMe,
      required super.user,
      required super.message});

  @override
  Widget buildChild(
      BuildContext context, Message message, bool isMe, UserInfo user) {
    var attachment = Attachment.fromMap(message.content);
    return GestureDetector(
        onTap: () {
          Get.to(() => PhotoViewPage(
                imageProvider: NetworkImage(attachment.rawPath),
                loadingChild: const Center(child: CircularProgressIndicator()),
                heroTag: attachment.name,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ));
        },
        child: Image.network(attachment.previewPath ?? attachment.rawPath));
  }
}
