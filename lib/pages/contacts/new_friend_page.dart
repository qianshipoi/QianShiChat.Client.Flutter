import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/models/friend_apply.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/providers/user_provider.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';

class NewFriendPage extends StatefulWidget {
  const NewFriendPage({super.key});

  @override
  State<NewFriendPage> createState() => _NewFriendPageState();
}

class _NewFriendPageState extends State<NewFriendPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final UserProvider _userProvider = Get.find();
  late Future<List<FriendApply>> _applyFuture;
  final roomsController = Get.find<RoomsController>();
  int beforeLastTime = 0;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      _applyFuture = _getApplyList();
    });
  }

  Future<List<FriendApply>> _getApplyList() async {
    var response = await _userProvider.friendApplyPending(20);
    var result = response.body!;
    if (!result.succeeded) {
      throw Exception(result.errors);
    }
    var paged = PagedList.fromMap(result.data);
    var apply = List<Map<String, dynamic>>.from(paged.items)
        .map((e) => FriendApply.fromMap(e))
        .toList();
    if (apply.isEmpty) {
      hasMore = false;
      return apply;
    }

    beforeLastTime = apply.last.createTime;
    hasMore = paged.hasNext;
    return apply;
  }

  Future _refresh() async {
    setState(() {
      beforeLastTime = 0;
      _applyFuture = _getApplyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globalization.newFriend.tr),
      ),
      body: _buildFutureBuilder(),
    );
  }

  _buildFutureBuilder() {
    return FutureBuilder(
      future: _applyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(Globalization.noNewInformationYet.tr),
            );
          } else {
            return _buildListView(snapshot.data!);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildListView(List<FriendApply> items) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Get.toNamed(RouterContants.userProfile,
                      arguments: items[index].friend.id);
                },
                title: Text(items[index].friend.nickName),
                leading: ClipOval(
                  child: Image.network(
                    items[index].friend.avatar,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                subtitle: Text(items[index].remark ?? ''),
                trailing: _buildTrailing(items[index]),
              )),
    );
  }

  Widget _buildTrailing(FriendApply item) {
    if (item.status == ApplyStatus.applied) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.grey,
              )),
        ],
      );
    } else if (item.status == ApplyStatus.passed) {
      return IconButton(
          onPressed: () {},
          icon: IconButton(
              onPressed: () async {
                var room = await roomsController.createRoom(
                    item.friend.id, MessageSendType.personal);
                Get.back();
                Get.toNamed(RouterContants.chat, arguments: room);
              },
              icon: const Icon(
                Icons.chat,
                color: Colors.green,
              )));
    } else if (item.status == ApplyStatus.rejected) {
      return Text(Globalization.rejected.tr);
    } else if (item.status == ApplyStatus.ignored) {
      return Text(Globalization.ignored.tr);
    } else {
      return const SizedBox.shrink();
    }
  }
}
