import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/providers/group_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';

class GroupsController extends GetxController {
  final _chatController = Get.find<ChatHubController>();
  final GroupProvider _groupProvider = Get.find();
  final groups = <Group>[].obs;
  final cacheGroups = <Group>[];
  @override
  void onInit() {
    super.onInit();
    ever(
        _chatController.isConnection,
        (callback) => {
              if (callback)
                {
                  _getGroups(),
                }
            });
  }

  Future<void> _getGroups() async {
    var response = await _groupProvider.getAll();
    var result = response.body!;
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
    var response = await _groupProvider.getGroup(id);

    var result = response.body!;
    if (!result.succeeded) {
      logger.e('获取群组失败');
      return null;
    }
    group = Group.fromMap(result.data);
    cacheGroups.add(group);
    return group;
  }
}
