import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/message.dart';

class AudioMessage extends StatefulWidget {
  final Message message;

  const AudioMessage(
    this.message, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(Icons.play_arrow), Text('...'), Text('00:00')],
    );
  }
}
