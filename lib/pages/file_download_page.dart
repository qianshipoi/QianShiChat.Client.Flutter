import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/attachment.dart';

class FileDownloadPage extends StatefulWidget {
  const FileDownloadPage({super.key});

  @override
  State<FileDownloadPage> createState() => _FileDownloadPageState();
}

class _FileDownloadPageState extends State<FileDownloadPage> {
  final Attachment attachment = Get.arguments;

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attachment.name),
      ),
      body: Center(
        child: Column(children: [
          Text(attachment.name),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text("Download")),
        ]),
      ),
    );
  }
}
