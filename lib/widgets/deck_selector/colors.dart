import 'package:flutter/material.dart';

Color getColor(String colorName) {
  switch (colorName) {
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'red':
      return Colors.red;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    default:
      return Colors.grey;
  }
}
