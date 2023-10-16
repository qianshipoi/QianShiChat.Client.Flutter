import 'dart:convert';

import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/userinfo.dart';

class FriendApply {
  int id;
  int userId;
  int friendId;
  int createTime;
  String? remark;
  ApplyStatus status;
  UserInfo? user;
  UserInfo friend;
  FriendApply({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.createTime,
    this.remark,
    required this.status,
    this.user,
    required this.friend,
  });

  FriendApply copyWith({
    int? id,
    int? userId,
    int? friendId,
    int? createTime,
    String? remark,
    ApplyStatus? status,
    UserInfo? user,
    UserInfo? friend,
  }) {
    return FriendApply(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      createTime: createTime ?? this.createTime,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      user: user ?? this.user,
      friend: friend ?? this.friend,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'createTime': createTime,
      'remark': remark,
      'status': status.number,
      'user': user?.toMap(),
      'friend': friend.toMap(),
    };
  }

  factory FriendApply.fromMap(Map<String, dynamic> map) {
    return FriendApply(
      id: map['id'] as int,
      userId: map['userId'] as int,
      friendId: map['friendId'] as int,
      createTime: map['createTime'] as int,
      remark: map['remark'] != null ? map['remark'] as String : null,
      status: ApplyStatus.fromValue(map['status'] as int),
      user: map['user'] != null
          ? UserInfo.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      friend: UserInfo.fromMap(map['friend'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendApply.fromJson(String source) =>
      FriendApply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendApply(id: $id, userId: $userId, friendId: $friendId, createTime: $createTime, remark: $remark, status: $status, user: $user, friend: $friend)';
  }

  @override
  bool operator ==(covariant FriendApply other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.friendId == friendId &&
        other.createTime == createTime &&
        other.remark == remark &&
        other.status == status &&
        other.user == user &&
        other.friend == friend;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        friendId.hashCode ^
        createTime.hashCode ^
        remark.hashCode ^
        status.hashCode ^
        user.hashCode ^
        friend.hashCode;
  }
}
