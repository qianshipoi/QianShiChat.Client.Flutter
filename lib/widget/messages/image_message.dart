import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/pages/photo_view_page.dart';

class ImageMessage extends StatefulWidget {
  final Message message;
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    var attachment = Attachment.fromMap(widget.message.content);
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
