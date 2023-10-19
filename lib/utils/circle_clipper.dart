import 'package:flutter/material.dart';
import 'dart:math';

class CircleClipper extends CustomClipper<Path> {
  final Animation<double> animation;

  CircleClipper({required this.animation}) : super(reclip: animation);

  Size? _size;

  late double _diagonal;

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: _getDiagonal(size) / 2 * animation.value));
  }

  double _getDiagonal(Size size) {
    if (size != _size) {
      _size = size;
      _diagonal = sqrt(size.width * size.width + size.height * size.height);
    }
    return _diagonal;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
