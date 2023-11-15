import 'package:get/get.dart';

import 'package:qianshi_chat/models/userinfo.dart';

class FriendGroup {
  final int id;
  final Rx<String> name;
  final int createTime;
  final bool isDefault;
  final Rx<int> sort;
  final Rx<int> totalCount;
  final RxList<UserInfo> friends;

  FriendGroup(this.id, String name, this.createTime, this.isDefault, int sort,
      int totalCount, List<UserInfo> friends)
      : name = name.obs,
        sort = sort.obs,
        totalCount = totalCount.obs,
        friends = friends.obs;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name.value,
      'createTime': createTime,
      'isDefault': isDefault,
      'sort': sort.value,
      'totalCount': totalCount.value,
      'friends': friends.map((e) => e.toMap()).toList(),
    };
  }

  factory FriendGroup.fromApiResultMap(Map<String, dynamic> map) {
    return FriendGroup(
        map['id'] as int,
        map['name'] as String,
        map['createTime'] as int,
        map['isDefault'] is bool,
        map['sort'] as int,
        0, []);
  }
}
