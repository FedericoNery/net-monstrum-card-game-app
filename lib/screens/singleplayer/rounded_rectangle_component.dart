import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RectanguloRedondeadoComponent extends PositionComponent {
  final Color color;
  final double top;
  final double left;
  final double width;
  final double height;
  final double borderRadius;

  RectanguloRedondeadoComponent({
    required this.top,
    required this.left,
    required this.color,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, width, height),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }
}
