import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/color.dart';
import 'package:net_monstrum_card_game/domain/card.dart' as CardPackage;

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
      ..strokeWidth = 3.0;

    final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(5.0));
    canvas.drawRRect(roundedRect, paint);
  }
}



class CartaWidget extends SpriteComponent {
  final CardPackage.Card card;
  final double x;
  final double y;
  bool isHidden = false;
  CartaWidget(this.card, this.x, this.y, this.isHidden): super(size: Vector2.all(64), position: Vector2(x, y));

  @override
  Future<void> onLoad() async {
    final uri = this.isHidden ? 'cards/card_back4.webp' : 'digimon/${this.card.digimonName}.jpg';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!this.isHidden){
      //print('${card.digimonName} - ${card.color}');
      final Rect bounds = Rect.fromLTWH(0, 0, 65, 65);
      final Paint paint = Paint()
        ..color = CardColor.toFlutterColor(card.color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(5.0));
      canvas.drawRRect(roundedRect, paint);

      // Dibuja valores de ataque y vida
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${this.card.attackPoints}|${this.card.healthPoints}',
          style: TextStyle(color: Colors.white, backgroundColor: Colors.black),
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(18.75, 68));
    }
  }

  @override
  void update(double dt) {
    // Implementa la lógica de actualización si es necesario
  }

  void reveal() async{
    this.isHidden = false;
    final uri = 'digimon/${this.card.digimonName}.jpg';
    this.sprite = await Sprite.load(uri);
  }
}