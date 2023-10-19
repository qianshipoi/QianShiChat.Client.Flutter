import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/pages/home/contacts_page.dart';
import 'package:qianshi_chat/pages/home/found_page.dart';
import 'package:qianshi_chat/pages/home/message_page.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';
import 'package:qianshi_chat/stores/groups_controller.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';
import 'package:qianshi_chat/stores/users_controller.dart';
import 'package:qianshi_chat/utils/circle_image_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List pages = [const MessagePage(), const FoundPage(), const ContactsPage()];
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
    const BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Found'),
    const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
  ];
  int currentPage = 0;
  final _boundaryKey = GlobalKey();
  ui.Image? _image;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyGreen = GlobalKey();
  late Offset _startOffset;

  @override
  void initState() {
    super.initState();
    Get.put(UsersController());
    Get.put(RoomsController());
    Get.put(GroupsController());
    Get.put(FriendsController());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _image = null;
          _controller.reset();
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureWidget() async {
    final boundary = _boundaryKey.currentContext?.findRenderObject();
    if (boundary?.debugNeedsPaint ?? true) {
      await Future.delayed(const Duration(milliseconds: 20));
      return await _captureWidget();
    }

    if (boundary != null && boundary is RenderRepaintBoundary) {
      final RenderBox renderBox =
          _keyGreen.currentContext?.findRenderObject() as RenderBox;
      final sizeGreen = renderBox.size;

      //获取当前屏幕位置
      final positionGreen = renderBox.localToGlobal(Offset.zero);
      _startOffset = Offset(positionGreen.dx + sizeGreen.width / 2,
          positionGreen.dy + sizeGreen.height / 2);

      final image = await boundary.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);
      setState(() {
        _image = image;
      });
      Future.delayed(const Duration(seconds: 0), () {
        _controller.forward();
      });
    }
  }

  Future<void> _switchTheme() async {
    await _captureWidget();
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
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
                children: [
                  DrawerHeader(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: GetX<CurrentUserController>(
                              builder: (controller) => Image.network(
                                controller.current.value!.avatar,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          IconButton(
                              key: _keyGreen,
                              onPressed: () => _switchTheme(),
                              icon: const Icon(Icons.camera_alt_outlined))
                        ],
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text('Messages'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  const ListTile(
                    title: Text("Logout"),
                    onTap: logout,
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: bottomItems,
                currentIndex: currentPage,
                onTap: (index) {
                  setState(() {
                    currentPage = index;
                  });
                }),
            body: pages[currentPage],
          ),
          _buildImageFromBytes()
        ],
      ),
    );
  }

  Widget _buildImageFromBytes() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          if (_image == null) {
            return const SizedBox.shrink();
          }

          return Positioned.fill(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter:
                  CircleImagePainter(_image!, _animation.value, _startOffset),
            ),
          );
        });
  }
}
