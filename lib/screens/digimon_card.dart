import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/color.dart';

class ImageCardExample extends SpriteComponent {
  final String imageUrl;
  final String color;
  ImageCardExample(this.imageUrl, this.color) : super(size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('digimon/$imageUrl.jpg' );

    /*add(RectangleComponent.fromRect(
      Rect.fromLTWH(10, 10, 100, 50),
    ));*/
    //sprite = await Sprite.load('digimon/$imageUrl.jpg' );

  }
 @override
  void render(Canvas canvas) async {
    super.render(canvas);
    final Rect bounds = Rect.fromLTWH(0, 0, 65, 65);
    final Paint paint = Paint()
      ..color = CardColor.toFlutterColor(this.color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0; // Ajusta el grosor del trazo

    // Dibuja solo el borde del rectángulo
    final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(5.0));
    canvas.drawRRect(roundedRect, paint);
  }
}