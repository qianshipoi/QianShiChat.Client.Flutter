import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/stores/index_controller.dart';
import 'package:qianshi_chat/utils/circle_image_painter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
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
    _indexController.useDarkTheme.value = !_indexController.useDarkTheme.value;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                title: const Text('SettingsPage'),
              ),
              body: ListView(
                children: [
                  Obx(
                    () => ListTile(
                      title: const Text("Use system theme"),
                      trailing: Switch(
                        value: _indexController.useSystemTheme.value,
                        onChanged: (value) {
                          _indexController.useSystemTheme.value = value;
                        },
                      ),
                    ),
                  ),
                  Obx(() => _buildCustomTheme()),
                ],
              )),
          _buildImageFromBytes(),
        ],
      ),
    );
  }

  Widget _buildCustomTheme() {
    if (_indexController.useSystemTheme.value) {
      return const SizedBox.shrink();
    }
    return ListTile(
      title: const Text('Theme'),
      trailing: Switch(
        key: _keyGreen,
        value: _indexController.useDarkTheme.value,
        onChanged: (value) {
          _switchTheme();
        },
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
