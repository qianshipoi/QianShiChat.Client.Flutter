import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/friend_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';

class FriendsController extends GetxController {
  final friends = <UserInfo>[].obs;
  final _chatController = Get.find<ChatHubController>();
  final FriendProvider _friendProvider = Get.find();

  @override
  void onInit() {
    super.onInit();

    ever(
        _chatController.isConnection,
        (callback) => {
              if (callback)
                {
                  _getFriends(),
                }
            });
  }

  _getFriends() async {
    var response = await _friendProvider.getFriends();
    var result = response.body!;
    if (!result.succeeded) {
      logger.e('获取好友失败');
      return;
    }
    friends.value = List<Map<String, dynamic>>.from(result.data)
        .map((e) => UserInfo.fromMap(e))
        .toList();
  }

  bool isFriend(UserInfo user) {
    return friends.any((element) => element.id == user.id);
  }
}
