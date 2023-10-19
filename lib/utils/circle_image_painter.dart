import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CircleImagePainter extends CustomPainter {
  final ui.Image image;
  final double radius;
  final Offset startOffset;

  CircleImagePainter(this.image, this.radius, this.startOffset);

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
  bool shouldRepaint(CircleImagePainter oldDelegate) => this != oldDelegate;
}
