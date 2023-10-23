import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/stores/index_controller.dart';
import 'package:qianshi_chat/utils/capture_util.dart';
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
  final GlobalKey _systemThemeKey = GlobalKey();
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

  Future<void> _captureWidget(GlobalKey key) async {
    var image = await CaptureUtil.captureWidget(
        _boundaryKey, MediaQuery.of(context).devicePixelRatio);
    if (image == null) {
      return;
    }
    if (key.currentContext != null) {
      _startOffset = CaptureUtil.getWidgetOffset(key);
    }
    setState(() {
      _image = image;
    });
    Future.delayed(Duration.zero, () {
      _controller.forward();
    });
  }

  Future<void> _switchTheme() async {
    await _captureWidget(_keyGreen);
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
                title: Text(Globalization.settings.tr),
              ),
              body: ListView(
                children: [
                  Obx(
                    () => ListTile(
                      title: Text(Globalization.useSystemTheme.tr),
                      trailing: Switch(
                        key: _systemThemeKey,
                        value: _indexController.useSystemTheme.value,
                        onChanged: (value) async {
                          await _captureWidget(_systemThemeKey);
                          _indexController.useSystemTheme.value = value;
                        },
                      ),
                    ),
                  ),
                  Obx(() => _buildCustomTheme()),
                  ListTile(
                    title: Text(Globalization.language.tr),
                    trailing: GetX<IndexController>(
                      builder: (controller) {
                        return DropdownButton(
                          value: controller.currentLanguage.value,
                          items: controller.languages
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.displayName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            controller.currentLanguage.value = value;
                          },
                        );
                      },
                    ),
                  )
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
      title: Text(Globalization.useDarkTheme.tr),
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
