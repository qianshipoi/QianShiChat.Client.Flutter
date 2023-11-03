import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/pages/home/contacts_page.dart';
import 'package:qianshi_chat/pages/home/message_page.dart';
import 'package:qianshi_chat/pages/home/my_page.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
import 'package:qianshi_chat/stores/friends_controller.dart';
import 'package:qianshi_chat/stores/groups_controller.dart';
import 'package:qianshi_chat/stores/index_controller.dart';
import 'package:qianshi_chat/stores/rooms_controller.dart';
import 'package:qianshi_chat/stores/users_controller.dart';
import 'package:qianshi_chat/utils/capture_util.dart';
import 'package:qianshi_chat/utils/circle_image_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final pages = [const MessagePage(), const ContactsPage(), const MyPage()];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: const Icon(Icons.message), label: Globalization.message.tr),
    BottomNavigationBarItem(
        icon: const Icon(Icons.people), label: Globalization.contacts.tr),
    BottomNavigationBarItem(
        icon: const Icon(Icons.person), label: Globalization.my.tr),
  ];
  int _currentPage = 0;
  final _boundaryKey = GlobalKey();
  ui.Image? _image;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyGreen = GlobalKey();
  late Offset _startOffset;
  final _indexController = Get.find<IndexController>();

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
    var image = await CaptureUtil.captureWidget(
        _boundaryKey, MediaQuery.of(context).devicePixelRatio);
    if (image == null) {
      return;
    }
    _startOffset = CaptureUtil.getWidgetOffset(_keyGreen);
    setState(() {
      _image = image;
    });
    Future.delayed(Duration.zero, () {
      _controller.forward();
    });
  }

  Future<void> _switchTheme() async {
    await _captureWidget();
    if (_indexController.useSystemTheme.value) {
      var isDarkTheme = Get.isDarkMode;
      _indexController.useSystemTheme.value = false;
      if (isDarkTheme) {
        _indexController.useDarkTheme.value = false;
      } else {
        _indexController.useDarkTheme.value = true;
      }
    } else {
      _indexController.useDarkTheme.value =
          !_indexController.useDarkTheme.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(bottomItems[_currentPage].label!),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => Get.toNamed(RouterContants.newGroup),
                    icon: const Icon(Icons.create))
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerHeader(),
                  ListTile(
                    onTap: () {
                      Get.toNamed(RouterContants.settings);
                    },
                    title: Text(Globalization.settings.tr),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                    title: Text(Globalization.login.tr),
                    onTap: logout,
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: bottomItems,
                currentIndex: _currentPage,
                onTap: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                }),
            body: pages[_currentPage],
          ),
          _buildImageFromBytes()
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: GetX<CurrentUserController>(
                builder: (controller) => GestureDetector(
                  onTap: () {
                    Get.toNamed(RouterContants.userProfile,
                        arguments: controller.current.value!.id);
                  },
                  child: Image.network(
                    controller.current.value!.avatar,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            IconButton(
                key: _keyGreen,
                onPressed: () => _switchTheme(),
                icon: const Icon(Icons.brightness_4))
          ],
        ),
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
