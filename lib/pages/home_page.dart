import 'package:flutter/material.dart';
import 'package:qianshi_chat/pages/found_page.dart';
import 'package:qianshi_chat/pages/friend_page.dart';
import 'package:qianshi_chat/pages/message_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pages = [const MessagePage(), const FoundPage(), const FriendPage()];
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
    const BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Found'),
    const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Messages'),
              trailing: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
          items: bottomItems,
          currentIndex: currentPage,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          }),
      body: pages[currentPage],
    );
  }
}
