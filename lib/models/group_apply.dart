import 'dart:convert';

import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/models/userinfo.dart';

class GroupApply {
  int id;
  int userId;
  int friendId;
  int createTime;
  String? remark;
  ApplyStatus status;
  UserInfo? user;
  Group group;
  GroupApply({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.createTime,
    this.remark,
    required this.status,
    this.user,
    required this.group,
  });

  GroupApply copyWith({
    int? id,
    int? userId,
    int? friendId,
    int? createTime,
    String? remark,
    ApplyStatus? status,
    UserInfo? user,
    Group? group,
  }) {
    return GroupApply(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      createTime: createTime ?? this.createTime,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      user: user ?? this.user,
      group: group ?? this.group,
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
      'group': group.toMap(),
    };
  }

  factory GroupApply.fromMap(Map<String, dynamic> map) {
    return GroupApply(
      id: map['id'] as int,
      userId: map['userId'] as int,
      friendId: map['friendId'] as int,
      createTime: map['createTime'] as int,
      remark: map['remark'] != null ? map['remark'] as String : null,
      status: ApplyStatus.fromValue(map['status'] as int),
      user: map['user'] != null
          ? UserInfo.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      group: Group.fromMap(map['group'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupApply.fromJson(String source) =>
      GroupApply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupApply(id: $id, userId: $userId, friendId: $friendId, createTime: $createTime, remark: $remark, status: $status, user: $user, group: $group)';
  }

  @override
  bool operator ==(covariant GroupApply other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.friendId == friendId &&
        other.createTime == createTime &&
        other.remark == remark &&
        other.status == status &&
        other.user == user &&
        other.group == group;
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
        group.hashCode;
  }
}
