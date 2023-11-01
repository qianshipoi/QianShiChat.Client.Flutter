import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/message.dart';

class TextMessage extends StatelessWidget {
  final Message message;
  const TextMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(message.content);
  }
}
