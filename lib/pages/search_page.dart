import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/group_provider.dart';
import 'package:qianshi_chat/providers/user_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final UserProvider _userProvider = Get.find();
  final GroupProvider _groupProvider = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final _users = <UserInfo>[];
  final _groups = <Group>[];

  _search() {
    var text = _searchController.text;
    logger.i(text);
    if (text.isEmpty) {
      return;
    }

    Future.wait([
      _userProvider.search(text, page: 1, size: 5),
      _groupProvider.search(text, page: 1, size: 5),
    ]).then((value) {
      var userPaged = PagedList.fromMap(value[0].body!.data);
      var groupPaged = PagedList.fromMap(value[1].body!.data);
      var users = List<Map<String, dynamic>>.from(userPaged.items)
          .map((e) => UserInfo.fromMap(e))
          .toList();
      var groups = List<Map<String, dynamic>>.from(groupPaged.items)
          .map((e) => Group.fromMap(e))
          .toList();

      setState(() {
        _users.clear();
        _groups.clear();
        _users.addAll(users);
        _groups.addAll(groups);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Globalization.search.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _searchController,
            onSubmitted: (value) => _search(),
            decoration: InputDecoration(
              hintText: Globalization.search.tr,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          ListView.builder(
              itemCount: _users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_users[index].avatar),
                  ),
                  title: Text(_users[index].nickName),
                  subtitle: Text(_users[index].id.toString()),
                  onTap: () {
                    Get.toNamed(RouterContants.userProfile,
                        arguments: _users[index].id);
                  },
                );
              }),
          ListView.builder(
              itemCount: _groups.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_groups[index].avatar),
                    ),
                    title: Text(_groups[index].name),
                    subtitle: Text(_groups[index].id.toString()),
                    onTap: () {
                      Get.toNamed(RouterContants.chat,
                          arguments: _groups[index]);
                    });
              }),
        ]),
      ),
    );
  }
}
