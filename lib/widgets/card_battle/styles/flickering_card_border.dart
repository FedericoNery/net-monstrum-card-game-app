import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../effects/effects.dart';

RectangleComponent getFlickeringCardBorder(){
  final Rect bounds = Rect.fromLTWH(-3, -3, 70, 91);
  final Paint paint = Paint()
    ..color = Colors.yellow
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  final shapeComponent = RectangleComponent.fromRect(bounds);
  shapeComponent.paint = paint;

  final effect = getFlickeringEffect();

  shapeComponent.add(effect);

  return shapeComponent;
}