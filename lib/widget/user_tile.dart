import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/userinfo.dart';

class UserTitl extends StatefulWidget {
  final UserInfo user;
  const UserTitl({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserTitl> createState() => _UserTitlState();
}

class _UserTitlState extends State<UserTitl> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          widget.user.avatar,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(widget.user.nickName),
      subtitle: _buildOnlineStatus(widget.user),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Get.toNamed(RouterContants.userProfile, arguments: widget.user.id);
      },
    );
  }

  Widget _buildOnlineStatus(UserInfo user) {
    if (user.isOnline) {
      return Row(
        children: [
          const Icon(
            Icons.circle,
            color: Colors.green,
            size: 14,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(Globalization.online.tr),
        ],
      );
    } else {
      return Row(
        children: [
          const Icon(Icons.circle, color: Colors.grey, size: 14),
          const SizedBox(
            width: 4,
          ),
          Text(Globalization.offline.tr),
        ],
      );
    }
  }
}
