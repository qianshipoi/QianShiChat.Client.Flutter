import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/enums/message_type.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/room.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/stores/users_controller.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Room room = Get.arguments;
  var currentUser = Get.find<CurrentUserController>().current.value!;
  var chatHubController = Get.find<ChatHubController>();
  var usersController = Get.find<UsersController>();
  var page = 1;
  var hasMore = true;
  List<Message> messages = [];
  final _scrollController = ScrollController();
  final _messageInputController = TextEditingController();
  bool _notSend = true;

  @override
  void initState() {
    super.initState();
    chatHubController.addPrivateChatListener(_privateChatListener);
    _getHistory().then((value) => {_jumpToBottom()});
  }

  void _privateChatListener(Message message) {
    setState(() {
      messages.add(message);
    });
    _jumpToBottom();
  }

  _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((duration) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    chatHubController.removePrivateChatListener(_privateChatListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future _sendTextMessage() async {
    var content = _messageInputController.value.text;
    if (content.isEmpty) return;
    logger.i('send message $content');
    var response = await HttpUtils.post('chat/text', data: {
      'message': content,
      'sendType': room.type.number,
      'toId': room.toObject.id,
    });
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      throw Exception(jsonEncode(result.errors));
    }
    _messageInputController.clear();
    var message = Message.fromMap(result.data);
    message.fromUser = currentUser;
    logger.i('send message $message');
    setState(() {
      messages.add(message);
      _jumpToBottom();
    });
  }

  Future _refresh() async {
    if (!hasMore) return;
    _getHistory();
  }

  Future _getHistory() async {
    var response =
        await HttpUtils.get("chat/${room.id}/history?page=$page&size=15");
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      throw Exception(jsonEncode(result.errors));
    }
    var pagedList = PagedList.fromMap(result.data);

    var data = List<Map<String, dynamic>>.from(pagedList.items)
        .map((e) => Message.fromMap(e))
        .toList();
    for (var element in data) {
      var user = await usersController.getUserById(element.fromId);
      element.fromUser = user;
    }
    setState(() {
      messages.insertAll(0, data);
      hasMore = pagedList.hasNext;
      page++;
    });
  }

  Widget buildFutureBuilder() {
    return RefreshIndicator(
        notificationPredicate: (notification) => hasMore,
        onRefresh: _refresh,
        child: buildListView(context, messages));
  }

  Widget buildListView(BuildContext context, List<Message> messages) {
    return ListView.separated(
        controller: _scrollController,
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
      return buildTextMessageView(message, isMe, message.fromUser!);
    }
    Attachment attachment = Attachment.fromMap(message.content);
    switch (message.messageType) {
      case MessageType.image:
        return buildImageMessageView(attachment, isMe, message.fromUser!);
      case MessageType.audio:
        return buildAudioMessageView(attachment, isMe, message.fromUser!);
      case MessageType.video:
        return const Text('Video');
      case MessageType.otherFile:
        return buildOtherFileMessageView(attachment, isMe, message.fromUser!);
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
          GestureDetector(
            onTap: () {
              Get.toNamed('/user_profile', arguments: user.id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
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
          GestureDetector(
            onTap: () {
              Get.toNamed('/user_profile', arguments: user.id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
          ),
      ],
    );
  }

  Widget buildTextMessageView(Message message, bool isMe, UserInfo user) {
    return buildBaseMessageView(isMe, user, Text(message.content));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(room.name ?? ""),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  color: Colors.blueGrey, child: buildFutureBuilder()),
            ),
            _buildMessageInputBuilder()
          ],
        ));
  }

  SizedBox _buildMessageInputBuilder() {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            const Icon(Icons.file_open_sharp),
            Expanded(
              child: TextField(
                controller: _messageInputController,
                onChanged: (value) {
                  setState(() {
                    _notSend = value.isEmpty;
                  });
                },
              ),
            ),
            AbsorbPointer(
              absorbing: _notSend,
              child: IconButton(
                onPressed: () {
                  _sendTextMessage();
                },
                icon: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
