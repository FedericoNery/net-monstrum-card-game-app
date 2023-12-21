import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ColorCounter extends PositionComponent {
  final Color color;

  ColorCounter(this.color);

  @override
  void render(Canvas canvas) {
    final Paint paint = Paint();
    paint.color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, 20.0, 20.0), paint);
  }
}