import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/stores/groups_controller.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return GetX<GroupsController>(
      builder: (controller) => ListView.builder(
        itemCount: controller.groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(
                controller.groups[index].avatar,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(controller.groups[index].name),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () =>
                Get.toNamed('/chat', arguments: controller.groups[index]),
          );
        },
      ),
    );
  }
}
