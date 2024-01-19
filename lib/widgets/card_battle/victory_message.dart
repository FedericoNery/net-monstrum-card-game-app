import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VictoryMessage extends Component {
  String text = "";

  @override
  void render(Canvas canvas) {
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 48.0),
      text: text,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, new Offset(350, 350));
  }

  @override
  void update(double t) {
  }
}
