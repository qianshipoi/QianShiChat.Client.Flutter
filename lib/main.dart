import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qianshi_chat/found.dart';
import 'package:qianshi_chat/friend.dart';
import 'package:qianshi_chat/message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      builder: (context, _) {
        return MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              child: const Text('Drawer Header'),
              decoration: BoxDecoration(color: Colors.deepPurple),
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
