import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/enums/message_status.dart';
import 'package:qianshi_chat/models/enums/message_type.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/room.dart';
import 'package:qianshi_chat/pages/chat/audio_message.dart';
import 'package:qianshi_chat/pages/chat/image_message.dart';
import 'package:qianshi_chat/pages/chat/other_file_message.dart';
import 'package:qianshi_chat/pages/chat/text_message.dart';
import 'package:qianshi_chat/pages/chat/video_message.dart';
import 'package:qianshi_chat/providers/attachment_provider.dart';
import 'package:qianshi_chat/providers/chat_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
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
  var attachmentProvider = Get.find<AttachmentProvider>();
  var chatProvider = Get.find<ChatProvider>();
  var page = 1;
  var hasMore = true;
  List<Message> messages = [];
  final _scrollController = ScrollController();
  final _messageInputController = TextEditingController();
  bool _notSend = true;
  bool _audioInput = false;
  bool _displayEmoji = false;
  bool _displayMoreAction = false;
  final _focusNode = FocusNode();
  final _emojiList = [
    '😀',
    '😄',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃'
  ];

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
    var user = isMe ? currentUser : message.fromUser!;
    if (message.messageType == MessageType.text) {
      return TextMessage(isMe: isMe, user: user, message: message);
    }
    switch (message.messageType) {
      case MessageType.image:
        return ImageMessage(isMe: isMe, user: user, message: message);
      case MessageType.audio:
        return AudioMessage(isMe: isMe, user: user, message: message);
      case MessageType.video:
        return VideoMessage(isMe: isMe, user: user, message: message);
      case MessageType.otherFile:
        return OtherFileMessage(isMe: isMe, user: user, message: message);
      default:
        return const Text('not support message type');
    }
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

  Widget _buildMessageInputBuilder() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _audioInput = !_audioInput;
                      });
                    },
                    icon: Icon(
                        _audioInput ? Icons.keyboard : Icons.multitrack_audio)),
                Expanded(
                  child: _audioInput
                      ? ElevatedButton(
                          onPressed: () {}, child: const Text("按住说话"))
                      : TextField(
                          controller: _messageInputController,
                          onChanged: (value) {
                            setState(() {
                              _notSend = value.isEmpty;
                            });
                          },
                        ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _displayEmoji = !_displayEmoji;
                        if (_displayEmoji) {
                          FocusScope.of(context).requestFocus(_focusNode);
                        }
                      });
                    },
                    icon: const Icon(Icons.emoji_emotions)),
                _notSend
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _displayMoreAction = !_displayMoreAction;
                            if (_displayMoreAction) {
                              FocusScope.of(context).requestFocus(_focusNode);
                            }
                          });
                        },
                        icon: const Icon(Icons.add))
                    : ElevatedButton(
                        onPressed: () {
                          _sendTextMessage();
                        },
                        child: const Text("发送")),
              ],
            ),
            _buildEmojiView(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiView() {
    if (!_displayEmoji) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: _emojiList.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                _messageInputController.text += _emojiList[index];
              },
              child: Center(child: Text(_emojiList[index])));
        },
      ),
    );
  }

  Future<void> _filePicker() async {
    var result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    var file = result.files.first;

    var attachment = await _uploadAttachment(file.path!);
    if (attachment == null) return;

    setState(() {
      messages.add(_sendAttachmentMessage(attachment));
    });
  }

  Message _sendAttachmentMessage(Attachment attachment) {
    var message = Message(
        id: DateTime.now().millisecondsSinceEpoch,
        roomId: room.id,
        createTime: DateTime.now().millisecondsSinceEpoch,
        attachments: [attachment],
        status: MessageStatus.sending,
        messageType: MessageType.otherFile,
        content: attachment.toMap(),
        fromId: currentUser.id,
        fromUser: currentUser,
        toId: room.toId,
        sendType: room.type);

    chatProvider.sendFile(room.toId, attachment.id, room.type).then((response) {
      if (response.hasError) {
        message.status = MessageStatus.failed;
        logger.e(response.statusText);
        return;
      }
      var result = response.body!;
      if (!result.succeeded) {
        message.status = MessageStatus.failed;
        return;
      }
      var returnMessage = Message.fromMap(result.data);
      message.id = returnMessage.id;
      message.status = MessageStatus.succeeded;
      message.createTime = returnMessage.createTime;
      message.messageType = returnMessage.messageType;
    });

    return message;
  }

  Future<Attachment?> _uploadAttachment(String filepath) async {
    var response =
        await attachmentProvider.upload(filepath, (double progressValue) {});

    if (response.hasError) {
      logger.e(response.statusText);
      return null;
    }
    return Attachment.fromMap(response.body!.data);
  }
}
