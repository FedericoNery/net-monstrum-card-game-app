import 'package:flutter/material.dart';

abstract class IColor{
  late String color;

  bool isRedColor();
  bool isBrownColor();
  bool isBlueColor();
  bool isWhiteColor();
  bool isBlackColor();
  bool isGreenColor();
}
class CardColor {
  static const String RED = 'Red';
  static const String BLUE = 'Blue';
  static const String BLACK = 'Black';
  static const String BROWN = 'Brown';
  static const String WHITE = 'White';
  static const String GREEN = 'Green';
  //TODO Diferenciarlo como utils, ya que estos colores son los de dominio
  // y el color que se utiliza acá es simplemente para diferenciarlo de la UI
  // ya que la carta no posee color por reglas
  static const String EQUIPMENT = 'Gray';
  static const String SUMMON = 'Yellow';

  static List<String> getAllColors() {
    return [CardColor.RED, CardColor.BLUE, CardColor.BLACK, CardColor.BROWN, CardColor.WHITE, CardColor.GREEN];
  }

  static Color toFlutterColor(String color) {
    Map<String, Color> colorStringToColorsFlutterMap = {
      CardColor.RED: Colors.red,
      CardColor.BLUE: Colors.blue,
      CardColor.BLACK: Colors.black,
      CardColor.BROWN: Colors.brown,
      CardColor.WHITE: Colors.white,
      CardColor.GREEN: Colors.green,
      CardColor.EQUIPMENT: Colors.grey,
      CardColor.SUMMON: Colors.yellow,
    };
    return colorStringToColorsFlutterMap[color]!;
  }
}
