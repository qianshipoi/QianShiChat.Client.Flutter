// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserInfo {
  int id;
  String account;
  String nickName;
  String avatar;
  int createTime;
  bool isOnline;
  String? alias;
  UserInfo({
    required this.id,
    required this.account,
    required this.nickName,
    required this.avatar,
    required this.createTime,
    required this.isOnline,
    this.alias,
  });

  UserInfo copyWith({
    int? id,
    String? account,
    String? nickName,
    String? avatar,
    int? createTime,
    bool? isOnline,
    String? alias,
  }) {
    return UserInfo(
      id: id ?? this.id,
      account: account ?? this.account,
      nickName: nickName ?? this.nickName,
      avatar: avatar ?? this.avatar,
      createTime: createTime ?? this.createTime,
      isOnline: isOnline ?? this.isOnline,
      alias: alias ?? this.alias,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'account': account,
      'nickName': nickName,
      'avatar': avatar,
      'createTime': createTime,
      'isOnline': isOnline,
      'alias': alias,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'] as int,
      account: map['account'] as String,
      nickName: map['nickName'] as String,
      avatar: map['avatar'] as String,
      createTime: map['createTime'] as int,
      isOnline: map['isOnline'] as bool,
      alias: map['alias'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfo(id: $id, account: $account, nickName: $nickName, avatar: $avatar, createTime: $createTime, isOnline: $isOnline, alias: $alias)';
  }

  @override
  bool operator ==(covariant UserInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.account == account &&
        other.nickName == nickName &&
        other.avatar == avatar &&
        other.createTime == createTime &&
        other.isOnline == isOnline &&
        other.alias == alias;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        account.hashCode ^
        nickName.hashCode ^
        avatar.hashCode ^
        createTime.hashCode ^
        isOnline.hashCode ^
        alias.hashCode;
  }
}
