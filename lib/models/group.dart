import 'dart:convert';

import 'package:qianshi_chat/models/userinfo.dart';

class Group {
  final int id;
  final int userId;
  final String name;
  final String avatar;
  final int totalUser;
  final int createTime;
  final List<UserInfo> users;

  Group({
    required this.id,
    required this.userId,
    required this.name,
    required this.avatar,
    required this.totalUser,
    required this.createTime,
    this.users = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'avatar': avatar,
      'totalUser': totalUser,
      'createTime': createTime,
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as int,
      userId: map['userId'] as int,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      totalUser: map['totalUser'] as int,
      createTime: map['createTime'] as int,
      users: List<UserInfo>.from(
        (map['users'] as List<int>).map<UserInfo>(
          (x) => UserInfo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);
}
