import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/pages/photo_view_page.dart';

class ImageMessage extends StatefulWidget {
  final Message message;
  const ImageMessage(
    this.message, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.message.attachments.map<Widget>((attachment) {
        var path = attachment.previewPath ?? attachment.rawPath;
        var isLocaleFile = !path.startsWith('http');
        return GestureDetector(
            onTap: () {
              Get.to(() => PhotoViewPage(
                    imageProvider: NetworkImage(attachment.rawPath),
                    loadingChild:
                        const Center(child: CircularProgressIndicator()),
                    heroTag: attachment.name,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                  ));
            },
            child: isLocaleFile ? Image.file(File(path)) : Image.network(path));
      }).toList(),
    );
  }
}
