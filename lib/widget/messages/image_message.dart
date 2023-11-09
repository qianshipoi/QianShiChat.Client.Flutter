import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/attachment.dart';

import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/pages/photo_view_page.dart';
import 'package:qianshi_chat/utils/common_util.dart';

// ignore: must_be_immutable
class ImageMessage extends StatefulWidget {
  late List<Attachment> attachments;
  ImageMessage(
    Message message, {
    super.key,
  }) {
    attachments = [Attachment.fromMap(message.content)];
  }

  @override
  State<StatefulWidget> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.attachments.map<Widget>((attachment) {
        var path = attachment.previewPath ?? attachment.rawPath;
        var isLocaleFile = CommonUtil.isLocaleFile(path);
        return GestureDetector(
          onTap: () {
            Get.to(() => PhotoViewPage(
                  imageProvider: isLocaleFile
                      ? FileImage(File(attachment.rawPath))
                      : NetworkImage(attachment.rawPath) as ImageProvider,
                  loadingChild: Stack(children: [
                    isLocaleFile ? Image.file(File(path)) : Image.network(path),
                    const Center(child: CircularProgressIndicator()),
                  ]),
                  heroTag: attachment.id.toString(),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                ));
          },
          child: Hero(
              tag: attachment.id.toString(),
              child:
                  isLocaleFile ? Image.file(File(path)) : Image.network(path)),
        );
      }).toList(),
    );
  }
}
