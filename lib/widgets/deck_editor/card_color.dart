import 'package:flutter/material.dart';

class CardColor {
  static const String RED = 'Red';
  static const String BLUE = 'Blue';
  static const String BLACK = 'Black';
  static const String BROWN = 'Brown';
  static const String WHITE = 'White';
  static const String GREEN = 'Green';

  static Color toFlutterColor(String? color) {
    Map<String, Color> colorStringToColorsFlutterMap = {
      CardColor.RED: Colors.red,
      CardColor.BLUE: Colors.blue,
      CardColor.BLACK: Colors.black,
      CardColor.BROWN: Colors.brown,
      CardColor.WHITE: Colors.white,
      CardColor.GREEN: Colors.green,
    };
    return color == null ? Colors.grey : colorStringToColorsFlutterMap[color]!;
  }
}
