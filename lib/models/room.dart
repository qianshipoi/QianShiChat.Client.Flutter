import 'dart:convert';

import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/models/userinfo.dart';

class Room {
  String id;
  int toId;
  MessageSendType type;
  int unreadCount;
  String? avatar;
  String? name;
  int lastMessageTime;
  dynamic lastMessageContent;
  UserInfo? fromUser;
  dynamic toObject;

  Room({
    required this.id,
    required this.toId,
    required this.type,
    required this.unreadCount,
    required this.lastMessageTime,
    this.name,
    this.avatar,
    this.lastMessageContent,
    this.fromUser,
    this.toObject,
  });

  factory Room.fromMap(Map<String, dynamic> json) {
    var type = MessageSendType.fromValue(json['type']);

    dynamic toObject;
    if (json['toObject'] != null && type == MessageSendType.group) {
      toObject = Group.fromJson(json['toObject']);
    } else if (json['toObject'] != null && type == MessageSendType.personal) {
      toObject = UserInfo.fromJson(json['toObject']);
    }

    dynamic messageContent = json['lastMessageContent'];
    if (messageContent != null) {
      if (messageContent is String) {
        messageContent = messageContent;
      } else if (messageContent is Map<String, dynamic>) {
        messageContent = Attachment.fromMap(messageContent);
      }
    }

    return Room(
      id: json['id'],
      toId: json['toId'],
      type: type,
      unreadCount: json['unreadCount'],
      avatar: json['avatar'],
      name: json['name'],
      lastMessageTime: json['lastMessageTime'],
      lastMessageContent: messageContent,
      fromUser:
          json['fromUser'] != null ? UserInfo.fromMap(json['fromUser']) : null,
      toObject: toObject,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'toId': toId,
      'type': type.number,
      'unreadCount': unreadCount,
      'avatar': avatar,
      'name': name,
      'lastMessageTime': lastMessageTime,
      'lastMessageContent': lastMessageContent,
      'fromUser': fromUser?.toMap(),
      'toObject': toObject,
    };
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);
}
