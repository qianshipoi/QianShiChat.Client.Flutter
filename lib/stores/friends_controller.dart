import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class FriendsController extends GetxController {
  final friends = <UserInfo>[].obs;
  final chatController = Get.find<ChatHubController>();

  @override
  void onInit() {
    super.onInit();

    ever(
        chatController.isConnection,
        (callback) => {
              if (callback)
                {
                  _getFriends(),
                }
            });
  }

  _getFriends() async {
    var response = await HttpUtils.get('friend');
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      logger.e('获取好友失败');
      return;
    }
    friends.value = List<Map<String, dynamic>>.from(result.data)
        .map((e) => UserInfo.fromMap(e))
        .toList();
  }
}
