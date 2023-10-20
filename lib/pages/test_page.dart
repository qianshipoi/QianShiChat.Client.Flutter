import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();
  Color _backroundColor = Colors.blue;
  ui.Image? _image;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyGreen = GlobalKey();
  late Offset _startOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _image = null;
          _backroundColor = Colors.blue;
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

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Full Screen Image'),
          ),
          body: Stack(
            children: [
              // 底部小部件
              Container(
                color: _backroundColor,
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: _keyGreen,
            onPressed: () => _captureWidget(),
            child: const Icon(Icons.camera_alt),
          ),
        ),
        _buildImageFromBytes()
      ]),
    );
  }

  Widget _buildImageFromBytes() {
    if (_image == null) {
      return const SizedBox();
    }
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          if (_image == null) {
            return const SizedBox();
          }

          return Positioned.fill(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ImagePainter(_image!, _animation.value, _startOffset),
            ),
          );
        });
  }

  void _captureWidget() async {
    final boundary = _boundaryKey.currentContext?.findRenderObject();
    if (boundary?.debugNeedsPaint ?? true) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _captureWidget();
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
        _backroundColor = Colors.grey;
      });
      Future.delayed(const Duration(seconds: 0), () {
        _controller.forward();
      });
    }
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final double radius;
  final Offset startOffset;

  _ImagePainter(this.image, this.radius, this.startOffset);

  @override
  void paint(Canvas canvas, Size size) async {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawColor(Colors.transparent, BlendMode.clear);
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final scale = size.shortestSide / imageSize.shortestSide;
    final matrix = Matrix4.identity()..scale(scale);
    canvas.transform(matrix.storage);
    canvas.drawImage(image, Offset.zero, Paint());

    final center = Offset(startOffset.dx / scale, startOffset.dy / scale);
    final paint = Paint()..blendMode = BlendMode.clear;
    canvas.drawCircle(center, radius / 100 * size.height / scale, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ImagePainter oldDelegate) => this != oldDelegate;
}
