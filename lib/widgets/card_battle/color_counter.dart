import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'counters_measures.dart';

class NewColorCounter extends PositionComponent {
  final Color color;
  final double x;
  final double y;
  int cantidad;
  final Color backgroundColor;

  NewColorCounter({
    required this.color,
    required this.x,
    required this.y,
    required this.cantidad,
    this.backgroundColor = const Color(0xFF333333),
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this.position = Vector2(x, y);

    final Paint colorBackgroundPaint = Paint()..color = backgroundColor;
    final RRect colorBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 22.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(colorBackgroundRect, colorBackgroundPaint);

    final Paint colorPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(1.0, 1.0, 20.0, 20.0), colorPaint);

    final Paint textBackgroundPaint = Paint()..color = backgroundColor;
    final RRect textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(26.0, 0, 24.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
    textPaint.render(canvas, '$cantidad', Vector2(30, 4));
  }
}

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

class ColorCounterInstances {
  NewColorCounter blueCounter = NewColorCounter(
      color: Colors.blueAccent,
      x: CountersMeasures.BLUE_X,
      y: CountersMeasures.BLUE_Y,
      cantidad: 0);
  NewColorCounter redCounter = NewColorCounter(
      color: Colors.red,
      x: CountersMeasures.RED_X,
      y: CountersMeasures.RED_Y,
      cantidad: 0);
  NewColorCounter brownCounter = NewColorCounter(
      color: Colors.brown,
      x: CountersMeasures.BROWN_X,
      y: CountersMeasures.BROWN_Y,
      cantidad: 0);
  NewColorCounter whiteCounter = NewColorCounter(
      color: Colors.white,
      x: CountersMeasures.WHITE_X,
      y: CountersMeasures.WHITE_Y,
      cantidad: 0);
  NewColorCounter blackCounter = NewColorCounter(
      color: Colors.black,
      x: CountersMeasures.BLACK_X,
      y: CountersMeasures.BLACK_Y,
      cantidad: 0);
  NewColorCounter greenCounter = NewColorCounter(
      color: Colors.green,
      x: CountersMeasures.GREEN_X,
      y: CountersMeasures.GREEN_Y,
      cantidad: 0);

  NewColorCounter blueCounterRival = NewColorCounter(
      color: Colors.blueAccent,
      x: CountersMeasures.BLUE_RIVAL_X,
      y: CountersMeasures.BLUE_RIVAL_Y,
      cantidad: 0);
  NewColorCounter redCounterRival = NewColorCounter(
      color: Colors.red,
      x: CountersMeasures.RED_RIVAL_X,
      y: CountersMeasures.RED_RIVAL_Y,
      cantidad: 0);
  NewColorCounter brownCounterRival = NewColorCounter(
      color: Colors.brown,
      x: CountersMeasures.BROWN_RIVAL_X,
      y: CountersMeasures.BROWN_RIVAL_Y,
      cantidad: 0);
  NewColorCounter whiteCounterRival = NewColorCounter(
      color: Colors.white,
      x: CountersMeasures.WHITE_RIVAL_X,
      y: CountersMeasures.WHITE_RIVAL_Y,
      cantidad: 0);
  NewColorCounter blackCounterRival = NewColorCounter(
      color: Colors.black,
      x: CountersMeasures.BLACK_RIVAL_X,
      y: CountersMeasures.BLACK_RIVAL_Y,
      cantidad: 0);
  NewColorCounter greenCounterRival = NewColorCounter(
      color: Colors.green,
      x: CountersMeasures.GREEN_RIVAL_X,
      y: CountersMeasures.GREEN_RIVAL_Y,
      cantidad: 0);

  ColorCounterInstances();
}
