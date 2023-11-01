import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';

class SelectFriends extends StatefulWidget {
  final List<UserInfo> selectedFriends;
  const SelectFriends({super.key, required this.selectedFriends});

  @override
  State<SelectFriends> createState() => _SelectFriendsState();
}

class _SelectFriendsState extends State<SelectFriends> {
  final FriendsController _friendsController = Get.find<FriendsController>();
  final List<UserInfo> selectedFriends = [];
  @override
  void initState() {
    super.initState();
    selectedFriends.addAll(widget.selectedFriends);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globalization.selectFriends.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Get.back(result: selectedFriends);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _friendsController.friends.length,
        itemBuilder: (context, index) {
          final friend = _friendsController.friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friend.avatar),
            ),
            title: Text(friend.nickName),
            trailing: Checkbox(
              value: selectedFriends.contains(friend),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedFriends.add(friend);
                  } else {
                    selectedFriends.remove(friend);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
