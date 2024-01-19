import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'counters_measures.dart';

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
  final blueCounter = ColorCounter(Colors.blueAccent);
  final redCounter = ColorCounter(Colors.red);
  final brownCounter = ColorCounter(Colors.brown);
  final whiteCounter = ColorCounter(Colors.white);
  final blackCounter = ColorCounter(Colors.black);
  final greenCounter = ColorCounter(Colors.green);

  final blueCounterRival = ColorCounter(Colors.blueAccent);
  final redCounterRival = ColorCounter(Colors.red);
  final brownCounterRival = ColorCounter(Colors.brown);
  final whiteCounterRival = ColorCounter(Colors.white);
  final blackCounterRival = ColorCounter(Colors.black);
  final greenCounterRival = ColorCounter(Colors.green);

  ColorCounterInstances(){
    blueCounter.x = CountersMeasures.BLUE_X;
    blueCounter.y = CountersMeasures.BLUE_Y;
    redCounter.x = CountersMeasures.RED_X;
    redCounter.y = CountersMeasures.RED_Y;
    brownCounter.x = CountersMeasures.BROWN_X;
    brownCounter.y = CountersMeasures.BROWN_Y;
    whiteCounter.x = CountersMeasures.WHITE_X;
    whiteCounter.y = CountersMeasures.WHITE_Y;
    blackCounter.x = CountersMeasures.BLACK_X;
    blackCounter.y = CountersMeasures.BLACK_Y;
    greenCounter.x = CountersMeasures.GREEN_X;
    greenCounter.y = CountersMeasures.GREEN_Y;

    blueCounterRival.x = CountersMeasures.BLUE_RIVAL_X;
    blueCounterRival.y = CountersMeasures.BLUE_RIVAL_Y;
    redCounterRival.x = CountersMeasures.RED_RIVAL_X;
    redCounterRival.y = CountersMeasures.RED_RIVAL_Y;
    brownCounterRival.x = CountersMeasures.BROWN_RIVAL_X;
    brownCounterRival.y = CountersMeasures.BROWN_RIVAL_Y;
    whiteCounterRival.x = CountersMeasures.WHITE_RIVAL_X;
    whiteCounterRival.y = CountersMeasures.WHITE_RIVAL_Y;
    blackCounterRival.x = CountersMeasures.BLACK_RIVAL_X;
    blackCounterRival.y = CountersMeasures.BLACK_RIVAL_Y;
    greenCounterRival.x = CountersMeasures.GREEN_RIVAL_X;
    greenCounterRival.y = CountersMeasures.GREEN_RIVAL_Y;
  }

}