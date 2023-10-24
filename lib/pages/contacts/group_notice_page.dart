import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/group_apply.dart';
import 'package:qianshi_chat/models/paged_list.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class GroupNoticePage extends StatefulWidget {
  const GroupNoticePage({super.key});

  @override
  State<GroupNoticePage> createState() => _GroupNoticePageState();
}

class _GroupNoticePageState extends State<GroupNoticePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<List<GroupApply>> _applyFuture;
  int beforeLastTime = 0;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _applyFuture = _getApplyList();
    });
  }

  Future<List<GroupApply>> _getApplyList() async {
    var response = await HttpUtils.get('group/apply/pending',
        params: {'size': 20, 'beforeLastTime': 0});
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      throw Exception(result.errors);
    }
    var paged = PagedList.fromMap(result.data);
    var apply = List<Map<String, dynamic>>.from(paged.items)
        .map((e) => GroupApply.fromMap(e))
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
        title: Text(Globalization.groupNotice.tr),
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

  _buildListView(List<GroupApply> items) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
                title: Text(items[index].group.name),
                leading: ClipOval(
                  child: Image.network(
                    items[index].group.avatar,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                subtitle: Text(items[index].remark ?? ''),
                trailing: _buildTrailing(items[index]),
              )),
    );
  }

  Widget _buildTrailing(GroupApply item) {
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
          icon: const Icon(
            Icons.chat,
            color: Colors.green,
          ));
    } else if (item.status == ApplyStatus.rejected) {
      return Text(Globalization.rejected.tr);
    } else if (item.status == ApplyStatus.ignored) {
      return Text(Globalization.ignored.tr);
    } else {
      return const SizedBox.shrink();
    }
  }
}
