import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/friend_group.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/friend_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';

class FriendsController extends GetxController {
  final friends = <FriendInfo>[].obs;
  final groups = <Rx<FriendGroup>>[].obs;
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
            .map((e) => FriendGroup.fromApiResultMap(e).obs)
            .toList();
        for (var element in groups) {
          logger.i(element.value);
        }
      }
      if (groups.isEmpty) {
        groups.add(
            FriendGroup(0, Globalization.myFriend.tr, 0, true, 0, 0, []).obs);
      }

      if (value[1].isOk && value[1].body!.succeeded) {
        friends.value = List<Map<String, dynamic>>.from(value[1].body!.data)
            .map((e) => FriendInfo.fromApiResultMap(e))
            .toList();
      }

      final defaultGroup =
          groups.firstWhere((element) => element.value.isDefault);

      final defaultFriends = friends
          .where((friend) =>
              friend.friendGroupId == defaultGroup.value.id ||
              friend.friendGroupId == 0)
          .toList();

      logger.i(defaultFriends);

      defaultGroup.value.friends.addAll(defaultFriends);

      for (var element in groups) {
        element.value.friends.addAll(friends
            .where((friend) => friend.friendGroupId == element.value.id)
            .toList());
      }
    });
  }

  Future<bool> addGroup(String name) async {
    return loading(() async {
      var result = await _friendProvider.addGroup(name);
      logger.i(result.body);
      if (result.isOk && result.body!.succeeded) {
        groups.add(FriendGroup.fromApiResultMap(result.body!.data).obs);
        return true;
      }
      return false;
    }, loadingText: Globalization.newFriendGroup.tr);
  }

  Future<bool> deleteGroup(int groupId) async {
    return loading(() async {
      var result = await _friendProvider.removeGroup(groupId);
      if (result.isOk && result.body!.succeeded) {
        groups.removeWhere((element) => element.value.id == groupId);
        return true;
      }
      return false;
    }, loadingText: Globalization.deleteFriendGroup.tr);
  }

  Future<bool> updateGroup(int groupId, String name) async {
    return loading(() async {
      var result = await _friendProvider.renameGroup(groupId, name);
      if (result.isOk && result.body!.succeeded) {
        var group = groups.firstWhere((element) => element.value.id == groupId);
        group.value.name.value = name;
        return true;
      }
      return false;
    }, loadingText: Globalization.renameFriendGroup.tr);
  }

  Future<TResult> loading<TResult>(Future<TResult> Function() func,
      {String? loadingText}) async {
    loadingText ??= Globalization.loading.tr;
    EasyLoading.show(status: loadingText, maskType: EasyLoadingMaskType.black);
    try {
      return await func();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> moveGroup() async {
    return loading<bool>(() async {
      var ids = groups.map((e) => e.value.id).toList();
      var result = await _friendProvider.sortGroup(ids);
      if (result.isOk && result.body!.succeeded) {
        return true;
      }
      return false;
    }, loadingText: Globalization.moveFriendGroup.tr);
  }

  Future<bool> moveFriendToGroup(int friendId, int groupId) async {
    return loading(() async {
      var result = await _friendProvider.moveFriendToGroup(friendId, groupId);
      if (result.isOk && result.body!.succeeded) {
        var friend = friends.firstWhere((element) => element.id == friendId);
        var oldGroup = groups
            .firstWhere((element) => element.value.id == friend.friendGroupId);
        oldGroup.value.friends.remove(friend);
        var newGroup =
            groups.firstWhere((element) => element.value.id == groupId);
        newGroup.value.friends.add(friend);
        friend.friendGroupId = groupId;
        return true;
      }
      return false;
    }, loadingText: Globalization.moveFriend.tr);
  }

  bool isFriend(UserInfo user) {
    return friends.any((element) => element.id == user.id);
  }
}
