import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/utils/common_util.dart';

// ignore: must_be_immutable
class OtherFileMessage extends StatefulWidget {
  Message message;
  late Attachment attachment;

  OtherFileMessage(this.message, {super.key}) {
    attachment = Attachment.fromMap(message.content);
  }

  @override
  State<OtherFileMessage> createState() => _OtherFileMessageState();
}

class _OtherFileMessageState extends State<OtherFileMessage> {
  @override
  Widget build(BuildContext context) {
    var attachment = Attachment.fromMap(widget.message.content);
    var size = CommonUtil.formatFileSize(attachment.size);
    var suffix = CommonUtil.getFileSuffix(attachment.name);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(attachment.name, style: const TextStyle(fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('size: '),
                Text(size),
              ],
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(suffix),
        ),
      ],
    );
  }
}
