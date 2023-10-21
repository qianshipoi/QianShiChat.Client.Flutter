import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/pages/contacts/friend_grouping_page.dart';
import 'package:qianshi_chat/pages/contacts/friends_page.dart';
import 'package:qianshi_chat/pages/contacts/groups_page.dart';
import 'package:qianshi_chat/utils/common_sliver_header_delegate.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, // 动画效果的异步处理
        length: 3 // tab 个数
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return SliverPersistentHeader(
        delegate: CommonSliverHeaderDelegate(
            islucency: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('新朋友'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.toNamed('/new_friend');
                      },
                    ),
                    ListTile(
                      title: const Text("群通知"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.toNamed('/group_notice');
                      },
                    )
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            //写类似于SliverAppBar中的title部分。可以自定义图标，标题，内容
            _buildHeader(),
            _buildTabsBar(),
            // SliverGrid(
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 3),
            //   delegate:
            //       SliverChildBuilderDelegate((BuildContext context, int index) {
            //     return Container(
            //       color: Colors.primaries[index % Colors.primaries.length],
            //     );
            //   }, childCount: 20),
            // )
          ];
        },
        body: TabBarView(
          controller: _tabController, //tabbar控制器
          children: const <Widget>[
            FriendsPage(),
            FriendGroupingPage(),
            GroupsPage(),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _buildTabsBar() {
    return SliverPersistentHeader(
        floating: true,
        pinned: true,
        delegate: CommonSliverHeaderDelegate(
            islucency: false,
            child: PreferredSize(
                preferredSize: const Size(double.infinity, 30),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        '好友',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        '分组',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        '群聊',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ))));
  }
}
