import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late Future<List<UserInfo>> _future;

  Future<List<UserInfo>> getFriends() async {
    var response = await HttpUtils.get("friend");
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      throw Exception(jsonEncode(result.errors));
    }
    List<Map<String, dynamic>> listMap =
        List<Map<String, dynamic>>.from(result.data);
    return listMap.map((e) => UserInfo.fromMap(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _future = getFriends();
  }

  Future refresh() async {
    setState(() {
      _future = getFriends();
    });
  }

  FutureBuilder<List<UserInfo>> buildFutureBuilder() {
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<List<UserInfo>> async) {
          if (async.connectionState == ConnectionState.active ||
              async.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (async.connectionState == ConnectionState.done) {
            if (async.hasError) {
              return const Center(
                child: Text("ERROR"),
              );
            } else if (async.hasData) {
              return RefreshIndicator(
                  onRefresh: refresh,
                  child: _buildListView(context, async.data!));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder();
  }

  _buildListView(BuildContext context, List<UserInfo> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(
                users[index].avatar,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(users[index].nickName),
            subtitle: _buildOnlineStatus(users[index]),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => Get.toNamed('/chat', arguments: users[index]),
          );
        });
  }

  Widget _buildOnlineStatus(UserInfo user) {
    if (user.isOnline) {
      return const Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.green,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text('在线'),
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(Icons.circle, color: Colors.grey, size: 14),
          SizedBox(
            width: 4,
          ),
          Text('离线'),
        ],
      );
    }
  }
}

