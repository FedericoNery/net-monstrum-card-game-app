import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

MoveEffect getUpAndDownEffect(bool selected, double x, double y){
  return MoveEffect.to(
    selected ? Vector2(x, y - 20) : Vector2(x, y),
    EffectController(
      duration: 0.1,
      curve: Curves.easeOut,
    ),
  );
}

MoveEffect getDrawMoveEffect(double initialX, double initialY, double finalX, double finalY){
  /* return MoveAlongPathEffect(
  Path()..quadraticBezierTo(finalX, finalY, initialX, initialY),
  EffectController(duration: 1.5),
  ); */

  return MoveEffect.to(Vector2(finalX, finalY),
    EffectController(
      duration: 0.4,
      curve: Curves.easeOutBack,
    ),
  );
}

ColorEffect getFlickeringEffect(){
  return ColorEffect(
    Colors.green,
    EffectController(duration: 0.25, infinite: true, reverseDuration: 0.25),
    opacityFrom: 0.2,
    opacityTo: 0.8,
  );
}

