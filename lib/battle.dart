import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

/// A component that renders the crate sprite, with a 16 x 16 size.
class ImageCardExample extends SpriteComponent {
  ImageCardExample() : super(size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('digimon/Agumon.jpg');
    //this.x = ;
/*
    width = sprite!.srcSize!.x;
    height = sprite!.srcSize!.y;
*/
  }
}

class ColorCounter extends PositionComponent {
  final Color color;

  ColorCounter(this.color);  // Incluir el tamaño en el constructor

  @override
  void render(Canvas canvas) {
    // Dibujar un cuadrado en el canvas
    final Paint paint = Paint();
    paint.color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, 20.0, 20.0), paint);  // Establecer el tamaño
  }
}


class Background extends SpriteComponent with HasGameRef {
  Background();
  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load("playmat/playmat.png");
    size = gameRef.size;
    sprite = Sprite(background);
  }
}

/*
void main() {
  final myGame = FlameGame(world: MyWorld());
  runApp(
    GameWidget(game: myGame),
  );
}*/
