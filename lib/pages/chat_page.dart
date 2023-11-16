import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/enums/message_status.dart';
import 'package:qianshi_chat/models/enums/message_type.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/room.dart';
import 'package:qianshi_chat/widget/file_upoad/message_attachment_upload_panel.dart';
import 'package:qianshi_chat/widget/messages/audio_message.dart';
import 'package:qianshi_chat/widget/messages/image_message.dart';
import 'package:qianshi_chat/widget/messages/other_file_message.dart';
import 'package:qianshi_chat/widget/messages/text_message.dart';
import 'package:qianshi_chat/widget/messages/video_message.dart';
import 'package:qianshi_chat/providers/attachment_provider.dart';
import 'package:qianshi_chat/providers/chat_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
import 'package:qianshi_chat/stores/users_controller.dart';
import 'package:qianshi_chat/utils/common_util.dart';
import 'package:qianshi_chat/widget/messages/base_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Room _room = Get.arguments;
  final ChatProvider _chatProvider = Get.find();
  final _currentUser = Get.find<CurrentUserController>().current.value!;
  final _chatHubController = Get.find<ChatHubController>();
  final _usersController = Get.find<UsersController>();
  final _attachmentProvider = Get.find<AttachmentProvider>();
  final _scrollController = ScrollController();
  final _messageInputController = TextEditingController();
  var _page = 1;
  final _hasMore = true.obs;
  final _messages = <Message>[].obs;
  final _notSend = true.obs;
  final _audioInput = false.obs;
  final _displayEmoji = false.obs;
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
  final _uploadingAttachments = <MessageAttachment>[
    // MessageAttachment(
    //   name: 'test',
    //   path: 'test',
    //   size: 100,
    //   progress: 0,
    // ),
    // MessageAttachment(
    //   name: 'test2',
    //   path: 'test2',
    //   size: 100,
    //   progress: 50,
    // ),
    // MessageAttachment(
    //   name: 'test3',
    //   path: 'test3',
    //   size: 100,
    //   progress: 99,
    // ),
  ].obs;

  @override
  void initState() {
    super.initState();
    _chatHubController.addPrivateChatListener(_privateChatListener);
    _getHistory().then((value) => {_jumpToBottom()});
  }

  void _privateChatListener(Message message) {
    _messages.add(message);
    _jumpToBottom();
  }

  _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((duration) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _chatHubController.removePrivateChatListener(_privateChatListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future _sendTextMessage() async {
    var content = _messageInputController.value.text;
    if (content.isEmpty) return;
    logger.i('send message $content');
    var response =
        await _chatProvider.sendText(_room.toId, content, _room.type);

    if (!response.body!.succeeded) {
      throw Exception(jsonEncode(response.body!.errors));
    }
    _messageInputController.clear();
    var message = Message.fromMap(response.body!.data);
    message.fromUser = _currentUser;
    logger.i('send message $message');
    _messages.add(message);
    _jumpToBottom();
  }

  Future<void> _showMoreActionBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Column(
              children: [
                ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: Text(Globalization.attachFile.tr),
                    onTap: _filePicker),
                ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(Globalization.takePhoto.tr),
                    onTap: _filePicker),
                ListTile(
                    leading: const Icon(Icons.video_call),
                    title: Text(Globalization.takeVideo.tr),
                    onTap: _filePicker),
              ],
            ),
          );
        });
  }

  Future<void> _refresh() async {
    if (!_hasMore.value) return;
    _getHistory();
  }

  Future<void> _getHistory() async {
    var response = await _chatProvider.history(_room.id, _page, size: 15);
    var result = response.body!;
    if (!result.succeeded) throw Exception(jsonEncode(result.errors));
    var pagedList = PagedList.fromMap(result.data);

    var data = List<Map<String, dynamic>>.from(pagedList.items)
        .map((e) => Message.fromMap(e))
        .toList();
    for (var element in data) {
      var user = await _usersController.getUserById(element.fromId);
      element.fromUser = user;
    }
    data.sort((a, b) => a.createTime.compareTo(b.createTime));
    _messages.insertAll(0, data);
    _hasMore.value = pagedList.hasNext;
    _page++;
  }

  Widget _buildListView(BuildContext context) {
    return RefreshIndicator(
        notificationPredicate: (notification) => _hasMore.value,
        onRefresh: _refresh,
        child: Obx(
          () => ListView.separated(
              controller: _scrollController,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildMessageView(context, _messages[index]))),
        ));
  }

  Widget _buildMessageView(BuildContext context, Message message) {
    var isMe = _currentUser.id == message.fromId;
    var user = isMe ? _currentUser : message.fromUser!;
    switch (message.messageType) {
      case MessageType.text:
        return BaseMessage(
            isMe: isMe,
            user: user,
            message: message,
            child: TextMessage(message));
      case MessageType.image:
        return BaseMessage(
            isMe: isMe,
            user: user,
            message: message,
            child: ImageMessage(message));
      case MessageType.audio:
        return BaseMessage(
            isMe: isMe,
            user: user,
            message: message,
            child: AudioMessage(message));
      case MessageType.video:
        return BaseMessage(
            isMe: isMe,
            user: user,
            message: message,
            child: VideoMessage(message));
      case MessageType.otherFile:
        return BaseMessage(
            isMe: isMe,
            user: user,
            message: message,
            child: OtherFileMessage(message));
      default:
        return const Text('not support message type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_room.name!),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.blueGrey,
                    child: _buildListView(context),
                  ),
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    right: 8.0,
                    child: MessageAttachmentUploadPanel(
                        attachments: _uploadingAttachments),
                  )
                ],
              ),
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
                    onPressed: () => _audioInput.value = !_audioInput.value,
                    icon: Obx(() => Icon(_audioInput.value
                        ? Icons.keyboard
                        : Icons.multitrack_audio))),
                Expanded(
                  child: (Obx(() => _audioInput.value
                      ? ElevatedButton(
                          onPressed: () {},
                          child: Text(Globalization.holdToTalk.tr))
                      : TextField(
                          controller: _messageInputController,
                          onChanged: (value) => _notSend.value = value.isEmpty,
                        ))),
                ),
                IconButton(
                    onPressed: () {
                      _displayEmoji.value = !_displayEmoji.value;
                      if (_displayEmoji.value) {
                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    },
                    icon: const Icon(Icons.emoji_emotions)),
                Obx(() => _notSend.value
                    ? IconButton(
                        onPressed: _showMoreActionBottomSheet,
                        icon: const Icon(Icons.add))
                    : ElevatedButton(
                        onPressed: _sendTextMessage,
                        child: Text(Globalization.send.tr))),
              ],
            ),
            Obx(() => _buildEmojiView()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiView() {
    if (!_displayEmoji.value) return const SizedBox.shrink();
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

    var message = _uploadAttachment(result.files.first, _sendAttachmentMessage);
    _messages.add(message);
  }

  Message _buildAttachmentMessage(Attachment attachment) {
    var messageType = MessageType.otherFile;
    switch (attachment.contentType) {
      case "image/jpeg":
      case "image/png":
      case "image/gif":
      case "image/wemb":
        messageType = MessageType.image;
        break;
      case "video/mp4":
        messageType = MessageType.video;
        break;
      case "audio/mpeg":
        messageType = MessageType.audio;
        break;
    }
    return Message(
        id: DateTime.now().millisecondsSinceEpoch,
        roomId: _room.id,
        createTime: DateTime.now().millisecondsSinceEpoch,
        attachments: [attachment],
        status: MessageStatus.sending,
        messageType: messageType,
        content: attachment.toMap(),
        fromId: _currentUser.id,
        fromUser: _currentUser,
        toId: _room.toId,
        sendType: _room.type);
  }

  void _sendAttachmentMessage(Message message) {
    _chatProvider
        .sendFile(_room.toId, message.attachments[0].id, _room.type)
        .then((response) {
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
  }

  Message _uploadAttachment(
      PlatformFile file, Function(Message) uploadComplete) {
    var filepath = file.path!;
    var attachment = Attachment(
        id: DateTime.timestamp().microsecond,
        name: CommonUtil.getFileName(filepath),
        rawPath: filepath,
        previewPath: filepath,
        hash: "",
        contentType: CommonUtil.getContentType(filepath),
        size: file.size);

    var message = _buildAttachmentMessage(attachment);

    var messageAttachment = MessageAttachment(
        name: attachment.name,
        path: attachment.rawPath,
        size: attachment.size,
        progress: 0);

    _attachmentProvider.upload(filepath, uploadProgress: (progress) {
      messageAttachment.progress = progress;
      _uploadingAttachments.refresh();
      attachment.progress = progress;
    }).then((response) {
      if (response.hasError) {
        logger.e(response.statusText);
        return null;
      }
      var newAttachment = Attachment.fromMap(response.body!.data);
      attachment.copyWith(
        id: newAttachment.id,
        name: newAttachment.name,
        rawPath: newAttachment.rawPath,
        previewPath: newAttachment.previewPath,
        hash: newAttachment.hash,
        contentType: newAttachment.contentType,
        size: newAttachment.size,
      );
      message.content = attachment.toMap();
      _uploadingAttachments.remove(messageAttachment);
      uploadComplete(message);
    });

    _uploadingAttachments.add(messageAttachment);

    return message;
  }
}
