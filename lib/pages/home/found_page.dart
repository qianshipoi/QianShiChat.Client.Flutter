import 'package:flutter/material.dart';
import 'package:qianshi_chat/utils/common_sliver_header_delegate.dart';

class FoundPage extends StatefulWidget {
  const FoundPage({super.key});

  @override
  State<StatefulWidget> createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage>
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
                delegate: CommonSliverHeaderDelegate(
                    islucency: true,
                    child: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: const Text('sdfsdf'),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: const Text('sdfsdf'),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        )))),
            SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: CommonSliverHeaderDelegate(
                    islucency: false,
                    child: PreferredSize(
                        preferredSize: const Size(double.infinity, 30),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: const <Widget>[
                            Tab(
                              child: Text('测试'),
                            ),
                            Tab(
                              child: Text('测试'),
                            ),
                            Tab(
                              child: Text('测试'),
                            ),
                          ],
                        )))),

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
            Text('sdf'),
            Text('sdf'),
            Text('sdf'),
          ],
        ),
      ),
    );
  }
}
