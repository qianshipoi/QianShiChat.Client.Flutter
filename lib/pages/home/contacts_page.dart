import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
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
    _tabController = TabController(vsync: this, length: 3);
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
                      title: Text(Globalization.newFriend.tr),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.toNamed(RouterContants.newFriend);
                      },
                    ),
                    ListTile(
                      title: Text(Globalization.groupNotice.tr),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.toNamed(RouterContants.groupNotice);
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
            _buildHeader(),
            _buildTabsBar(),
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
                        Globalization.firend.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        Globalization.grouping.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        Globalization.group.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ))));
  }
}
