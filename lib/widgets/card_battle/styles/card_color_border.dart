import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../domain/card/color.dart';

RRect getCardColorBorder(String color){
  final Rect bounds = Rect.fromLTWH(0, 0, 65, 85);
  final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(5.0));
  return roundedRect;
}

void drawCardColor(Canvas canvas, String color){
  final roundedRect = getCardColorBorder(color);
  final Paint paint = Paint()
    ..color = CardColor.toFlutterColor(color)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;
  canvas.drawRRect(roundedRect, paint);
}