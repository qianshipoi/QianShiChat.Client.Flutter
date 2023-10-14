import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/enums/message_type.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future _future;
  UserInfo user = Get.arguments;
  var currentUser = Get.find<CurrentUserController>().current.value!;
  var page = 1;
  var hasMore = true;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _future = getHistory();
  }

  Future refresh() async {
    if (!hasMore) return;
    setState(() {
      _future = getHistory();
    });
  }

  Future getHistory() async {
    var roomId = currentUser.id < user.id
        ? '${currentUser.id}-${user.id}'
        : '${user.id}-${currentUser.id}';
    logger.i(roomId);

    var response =
        await HttpUtils.get("chat/personal-$roomId/history?page=$page");
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      throw Exception(jsonEncode(result.errors));
    }
    var pagedList = PagedList.fromMap(result.data);

    var listMap = List<Map<String, dynamic>>.from(pagedList.items);
    var data = listMap.map((e) => Message.fromMap(e)).toList();
    setState(() {
      messages.insertAll(0, data);
      hasMore = pagedList.hasNext;
      page++;
    });
    logger.i(data);
    return data;
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot async) {
          if (async.connectionState == ConnectionState.active ||
              async.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (async.connectionState == ConnectionState.done) {
            if (async.hasError) {
              return const Center(
                child: Text("ERROR"),
              );
            } else if (async.hasData) {
              return RefreshIndicator(
                  notificationPredicate: (notification) => hasMore,
                  onRefresh: refresh,
                  child: buildListView(context, messages));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildListView(BuildContext context, List<Message> messages) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 12,
            ),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: buildMessageView(context, messages[index]));
        });
  }

  Widget buildMessageView(BuildContext context, Message message) {
    var isMe = currentUser.id == message.fromId;
    if (message.messageType == MessageType.text) {
      return buildTextMessageView(message, isMe, isMe ? currentUser : user);
    }
    Attachment attachment = Attachment.fromMap(message.content);
    switch (message.messageType) {
      case MessageType.image:
        return buildImageMessageView(
            attachment, isMe, isMe ? currentUser : user);
      case MessageType.audio:
        return buildAudioMessageView(
            attachment, isMe, isMe ? currentUser : user);
      case MessageType.video:
        return const Text('Video');
      case MessageType.otherFile:
        return buildOtherFileMessageView(
            attachment, isMe, isMe ? currentUser : user);
      default:
        return const Text('not support message type');
    }
  }

  Widget buildVideoMessageView(
      Attachment attachment, bool isMe, UserInfo user) {
    return buildBaseMessageView(isMe, user, const Text('Video'));
  }

  Widget buildAudioMessageView(Attachment arguments, bool isMe, UserInfo user) {
    return buildBaseMessageView(
        isMe,
        user,
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.play_arrow), Text('...'), Text('00:00')],
        ));
  }

  String formatFileSize(int size) {
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)}MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
    }
  }

  String getFileSuffix(String fileName) {
    return fileName.substring(fileName.lastIndexOf('.') + 1);
  }

  Widget buildOtherFileMessageView(
      Attachment attachment, bool isMe, UserInfo user) {
    var size = formatFileSize(attachment.size);
    var suffix = getFileSuffix(attachment.name);

    return buildBaseMessageView(
        isMe,
        user,
        Row(
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
        ));
  }

  Widget buildImageMessageView(
      Attachment attachment, bool isMe, UserInfo user) {
    return buildBaseMessageView(isMe, user, Image.network(attachment.rawPath));
  }

  Widget buildBaseMessageView(bool isMe, UserInfo user, Widget child) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
          ),
        Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 96,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(8)),
            child: child),
        if (isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
          ),
      ],
    );
  }

  Widget buildTextMessageView(Message message, bool isMe, UserInfo user) {
    return buildBaseMessageView(isMe, user, Text(message.content));
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(user.nickName),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  color: Colors.blueGrey, child: buildFutureBuilder()),
            ),
            const SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.file_open_sharp),
                    Expanded(
                      child: TextField(),
                    ),
                    Icon(Icons.send),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
