import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/message.dart';

class TextMessage extends StatelessWidget {
  final Message message;
  const TextMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(message.content);
  }
}
