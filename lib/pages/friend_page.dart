import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late Future<List<UserInfo>> _future;

  Future<List<UserInfo>> getFriends() async {
    var dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
    dio.options.headers['Client-Type'] = clientType;
    var preferences = await SharedPreferences.getInstance();

    logger.i(preferences.containsKey(accessTokenKey));
    if (preferences.containsKey(accessTokenKey)) {
      dio.options.headers['Authorization'] =
          'Bearer ${preferences.getString(accessTokenKey)}';
    }
    var response = await dio.get("friend");

    List<Map<String, dynamic>> listMap =
        List<Map<String, dynamic>>.from(response.data['data']);
    logger.i(listMap);
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
                  child: buildListView(context, async.data!));
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

  buildListView(BuildContext context, List<UserInfo> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].nickName),
            subtitle: buildOnlineStatus(users[index]),
            trailing: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: () => Get.toNamed('/chat', arguments: users[index])),
          );
        });
  }

  Widget buildOnlineStatus(UserInfo user) {
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
