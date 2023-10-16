import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class GroupsController extends GetxController {
  final chatController = Get.find<ChatHubController>();
  final currentUserController = Get.find<CurrentUserController>();
  final groups = <Group>[].obs;
  var cacheGroups = <Group>[];
  @override
  void onInit() {
    super.onInit();
    ever(
        chatController.isConnection,
        (callback) => {
              if (callback)
                {
                  _getGroups(),
                }
            });
  }

  Future<void> _getGroups() async {
    var response = await HttpUtils.get('group');
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      logger.e('获取群组失败');
      return;
    }
    groups.value = List<Map<String, dynamic>>.from(result.data)
        .map((e) => Group.fromMap(e))
        .toList();
  }

  Future<Group?> getGroupById(int id) async {
    // from my group
    var group = groups.firstWhereOrNull((element) => element.id == id);
    if (group != null) return group;

    // from cache
    group = cacheGroups.firstWhereOrNull((element) => element.id == id);
    if (group != null) return group;

    // from server
    var response = await HttpUtils.get('group/$id');
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      logger.e('获取群组失败');
      return null;
    }
    group = Group.fromMap(result.data);
    cacheGroups.add(group);
    return group;
  }
}
