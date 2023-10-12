import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:qianshi_chat/models/userinfo.dart';

import 'attachment.dart';
import 'enums/message_send_type.dart';
import 'enums/message_status.dart';
import 'enums/message_type.dart';

class Message {
  int id;
  int fromId;
  int toId;
  String roomId;
  MessageSendType sendType;
  MessageType messageType;
  dynamic content;
  int createTime;
  UserInfo? fromUser;
  MessageStatus status;
  List<Attachment> attachments;
  Message({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.roomId,
    required this.content,
    required this.createTime,
    this.fromUser,
    required this.attachments,
    required this.sendType,
    required this.messageType,
    required this.status,
  });

  Message copyWith({
    int? id,
    int? fromId,
    int? toId,
    String? roomId,
    dynamic content,
    int? createTime,
    UserInfo? fromUser,
    MessageStatus? status,
    MessageType? messageType,
    MessageSendType? sendType,
    List<Attachment>? attachments,
  }) {
    return Message(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      createTime: createTime ?? this.createTime,
      fromUser: fromUser ?? this.fromUser,
      attachments: attachments ?? this.attachments,
      sendType: sendType ?? this.sendType,
      messageType: messageType ?? this.messageType,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fromId': fromId,
      'toId': toId,
      'roomId': roomId,
      'content': content,
      'createTime': createTime,
      'fromUser': fromUser?.toMap(),
      'attachments': attachments.map((x) => x.toMap()).toList(),
      'sendType': sendType.number,
      'messageType': messageType.number,
      'status': status.number,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int,
      fromId: map['fromId'] as int,
      toId: map['toId'] as int,
      roomId: map['roomId'] as String,
      content: map['content'] as dynamic,
      createTime: map['createTime'] as int,
      sendType: MessageSendType.values[map['sendType'] as int],
      messageType: MessageType.fromValue(map['messageType'] as int),
      status: MessageStatus.values[map['status'] ?? 0],
      fromUser: map['fromUser'] != null
          ? UserInfo.fromMap(map['fromUser'] as Map<String, dynamic>)
          : null,
      attachments: List<Attachment>.from(
        (map['attachments'] as List<dynamic>).map<Attachment>(
          (x) => Attachment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, fromId: $fromId, toId: $toId, roomId: $roomId, content: $content, createTime: $createTime, sendType: $sendType, messageType: $messageType, status: $status, fromUser: $fromUser, attachments: $attachments)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fromId == fromId &&
        other.toId == toId &&
        other.roomId == roomId &&
        other.content == content &&
        other.createTime == createTime &&
        other.fromUser == fromUser &&
        other.status == status &&
        other.sendType == sendType &&
        other.messageType == messageType &&
        listEquals(other.attachments, attachments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fromId.hashCode ^
        toId.hashCode ^
        roomId.hashCode ^
        content.hashCode ^
        createTime.hashCode ^
        fromUser.hashCode ^
        status.hashCode ^
        sendType.hashCode ^
        messageType.hashCode ^
        attachments.hashCode;
  }
}
