import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoMessage extends StatefulWidget {
  final Message message;
  late Attachment attachment;
  VideoMessage({super.key, required this.message}) {
    attachment = Attachment.fromMap(message.content);
  }

  @override
  State<StatefulWidget> createState() => VideoMessageState();
}

class VideoMessageState extends State<VideoMessage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.attachment.rawPath));
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_videoPlayerController);
  }
}
