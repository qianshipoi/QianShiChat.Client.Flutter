import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/friend_group.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/friend_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';

class FriendsController extends GetxController {
  final friends = <FriendInfo>[].obs;
  final groups = <FriendGroup>[].obs;
  final ChatHubController _chatController = Get.find();
  final FriendProvider _friendProvider = Get.find();

  @override
  void onInit() {
    super.onInit();

    ever(_chatController.isConnection, (callback) {
      if (callback) _getFriends();
    });
  }

  _getFriends() async {
    Future.wait(
            [_friendProvider.getFriendGroups(), _friendProvider.getFriends()])
        .then((value) {
      if (value[0].isOk && value[0].body!.succeeded) {
        groups.value = List<Map<String, dynamic>>.from(value[0].body!.data)
            .map((e) => FriendGroup.fromApiResultMap(e))
            .toList();
      }
      if (groups.isEmpty) {
        groups.add(FriendGroup(0, '我的好友', 0, true, 0, 0, []));
      }

      if (value[1].isOk && value[1].body!.succeeded) {
        friends.value = List<Map<String, dynamic>>.from(value[1].body!.data)
            .map((e) => FriendInfo.fromApiResultMap(e))
            .toList();
      }

      for (var element in groups) {
        element.friends.addAll(friends
            .where((friend) => friend.friendGroupId == element.id)
            .toList());
      }
    });
  }

  Future<bool> addGroup(String name) async {
    return loading(() async {
      // await Future.delayed(const Duration(seconds: 2));
      // groups.add(
      //     FriendGroup(DateTime.now().microsecond, name, 0, false, 0, 0, []));
      // return true;
      var result = await _friendProvider.addGroup(name);
      logger.i(result.body);
      if (result.isOk && result.body!.succeeded) {
        groups.add(FriendGroup.fromApiResultMap(result.body!.data));
        return true;
      }
      return false;
    }, loadingText: '添加分组');
  }

  Future<bool> deleteGroup(int groupId) async {
    return loading(() async {
      // await Future.delayed(const Duration(seconds: 2));
      // groups.removeWhere((element) => element.id == groupId);
      // return true;
      var result = await _friendProvider.removeGroup(groupId);
      if (result.isOk && result.body!.succeeded) {
        groups.removeWhere((element) => element.id == groupId);
        return true;
      }
      return false;
    }, loadingText: '删除分组');
  }

  Future<bool> updateGroup(int groupId, String name) async {
    return loading(() async {
      // await Future.delayed(const Duration(seconds: 2));
      // var group = groups.firstWhere((element) => element.id == groupId);
      // group.name.value = name;
      // return true;
      var result = await _friendProvider.renameGroup(groupId, name);
      if (result.isOk && result.body!.succeeded) {
        var group = groups.firstWhere((element) => element.id == groupId);
        group.name.value = name;
        return true;
      }
      return false;
    }, loadingText: "更新组名");
  }

  Future<TResult> loading<TResult>(Future<TResult> Function() func,
      {String? loadingText = 'loading'}) async {
    EasyLoading.show(status: loadingText, maskType: EasyLoadingMaskType.black);
    try {
      return await func();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> moveGroup() async {
    return loading<bool>(() async {
      // await Future.delayed(const Duration(seconds: 2));
      // return true;
      var ids = groups.map((e) => e.id).toList();
      var result = await _friendProvider.sortGroup(ids);
      if (result.isOk && result.body!.succeeded) {
        return true;
      }
      return false;
    }, loadingText: '正在移动分组');
  }

  Future<bool> moveFriendToGroup(int friendId, int groupId) async {
    return loading(() async {
      // await Future.delayed(const Duration(seconds: 2));
      // var friend = friends.firstWhere((element) => element.id == friendId);
      // friend.friendGroupId = groupId;
      // return true;
      var result = await _friendProvider.moveFriendToGroup(friendId, groupId);
      if (result.isOk && result.body!.succeeded) {
        var friend = friends.firstWhere((element) => element.id == friendId);
        var oldGroup =
            groups.firstWhere((element) => element.id == friend.friendGroupId);
        oldGroup.friends.remove(friend);
        var newGroup = groups.firstWhere((element) => element.id == groupId);
        newGroup.friends.add(friend);
        friend.friendGroupId = groupId;
        return true;
      }
      return false;
    }, loadingText: 'move friend');
  }

  bool isFriend(UserInfo user) {
    return friends.any((element) => element.id == user.id);
  }
}
