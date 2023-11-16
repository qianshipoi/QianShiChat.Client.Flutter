import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/friend_group.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';

class FriendGroupManagePage extends StatefulWidget {
  const FriendGroupManagePage({super.key});

  @override
  State<FriendGroupManagePage> createState() => _FriendGroupManagePageState();
}

class _FriendGroupManagePageState extends State<FriendGroupManagePage> {
  final friendsController = Get.find<FriendsController>();
  final TextEditingController _groupNameController = TextEditingController();

  _add() {
    _groupNameController.clear();
    Get.defaultDialog(
      title: '新建分组',
      content: TextField(
        controller: _groupNameController,
        autofocus: true,
      ),
      textConfirm: '确定',
      textCancel: '取消',
      onConfirm: () {
        friendsController.addGroup(_groupNameController.text);
        setState(() {});
        Get.back();
      },
      onCancel: () {
        _groupNameController.clear();
        Get.back();
      },
    );
  }

  _edit(FriendGroup group) {
    _groupNameController.text = group.name.value;
    Get.defaultDialog(
      title: '编辑分组',
      content: TextField(
        controller: _groupNameController,
        autofocus: true,
      ),
      textConfirm: '确定',
      textCancel: '取消',
      onConfirm: () {
        friendsController.updateGroup(group.id, _groupNameController.text);
        setState(() {});
        Get.back();
      },
      onCancel: () {
        _groupNameController.clear();
        Get.back();
      },
    );
  }

  _delete(int id) {
    Get.defaultDialog(
      title: '删除分组',
      content: const Text('确定删除该分组吗？'),
      textConfirm: '确定',
      textCancel: '取消',
      onConfirm: () {
        friendsController.deleteGroup(id);
        setState(() {});
        Get.back();
      },
      onCancel: () {
        _groupNameController.clear();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分组管理')),
      body: Obx(() {
        return ReorderableListView.builder(
          header: ListTile(
            leading: const Icon(Icons.add),
            title: const Text('新建分组'),
            onTap: _add,
          ),
          buildDefaultDragHandles: true,
          itemBuilder: (context, index) {
            var group = friendsController.groups[index];
            return ListTile(
              key: ValueKey(group.id),
              onTap: () => _edit(group),
              title: Text(group.name.value),
              leading: group.isDefault
                  ? const Icon(Icons.remove_circle)
                  : GestureDetector(
                      onTap: () => _delete(group.id),
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
              trailing: ReorderableDragStartListener(
                  index: index, child: const Icon(Icons.menu)),
            );
          },
          itemCount: friendsController.groups.length,
          onReorder: (oldIndex, newIndex) async {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final FriendGroup group =
                friendsController.groups.removeAt(oldIndex);
            friendsController.groups.insert(newIndex, group);
            await friendsController.moveGroup();
          },
        );
      }),
    );
  }
}
