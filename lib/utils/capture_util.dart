import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CaptureUtil {
  static Future<ui.Image?> captureWidget(
      GlobalKey boundaryKey, double devicePixelRatio) async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary?.debugNeedsPaint ?? true) {
      await Future.delayed(const Duration(milliseconds: 20));
      return await captureWidget(boundaryKey, devicePixelRatio);
    }

    if (boundary != null && boundary is RenderRepaintBoundary) {
      return await boundary.toImage(pixelRatio: devicePixelRatio);
    } else {
      return null;
    }
  }

  static Offset getWidgetOffset(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    return Offset(position.dx + size.width / 2, position.dy + size.height / 2);
  }
}
