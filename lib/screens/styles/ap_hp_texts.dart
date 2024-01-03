import 'package:flutter/material.dart';

void drawBackgroundApHp(Canvas canvas){
  final Paint paintBlack = Paint()
    ..color = Colors.black;
  final Rect boundsBlack = Rect.fromLTWH(0, 64, 64.5, 20);
  final RRect roundedRectBlack = RRect.fromRectAndRadius(boundsBlack, Radius.circular(5.0));

  canvas.drawRRect(roundedRectBlack, paintBlack);
}

void drawApHpTexts(Canvas canvas, int attackPoints, int healthPoints){
  // Dibuja valores de ataque y vida
  final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${attackPoints} | ${healthPoints}',
        style: TextStyle(color: Colors.white, backgroundColor: Colors.black),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
  );

  textPainter.layout();
  textPainter.paint(canvas, Offset(15, 65));
}