import 'package:flutter/material.dart';

class MessageAttachment {
  final String name;
  final String path;
  final int size;
  double progress = 0.0;

  MessageAttachment(
      {required this.name,
      required this.path,
      required this.size,
      this.progress = 0.0});
}

class MessageAttachmentUploadPanel extends StatefulWidget {
  final List<MessageAttachment> attachments;
  const MessageAttachmentUploadPanel({
    Key? key,
    required this.attachments,
  }) : super(key: key);

  @override
  State<MessageAttachmentUploadPanel> createState() =>
      _MessageAttachmentUploadPanelState();
}

class _MessageAttachmentUploadPanelState
    extends State<MessageAttachmentUploadPanel> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.attachments.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final attachment = widget.attachments[index];
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              leading: const Icon(Icons.file_copy),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style: Theme.of(context).textTheme.bodySmall,
                    attachment.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: attachment.progress),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    widget.attachments.removeAt(index);
                  });
                },
              )),
        );
      },
    );
  }
}
