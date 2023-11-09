import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/utils/common_util.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoMessage extends StatefulWidget {
  final Message message;
  late Attachment _attachment;
  VideoMessage(this.message, {super.key}) {
    _attachment = message.attachments[0];
  }

  @override
  State<VideoMessage> createState() => VideoMessageState();
}

class VideoMessageState extends State<VideoMessage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        !CommonUtil.isLocaleFile(widget._attachment.rawPath)
            ? VideoPlayerController.networkUrl(
                Uri.parse(widget._attachment.rawPath))
            : VideoPlayerController.file(File(widget._attachment.rawPath));
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_videoPlayerController);
  }
}
