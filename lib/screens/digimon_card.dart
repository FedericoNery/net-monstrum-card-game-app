import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/color.dart';
import 'package:net_monstrum_card_game/domain/card.dart' as CardPackage;

class CartaWidget extends SpriteComponent with TapCallbacks {
  final CardPackage.Card card;
  final double x;
  final double y;
  bool isHidden = false;
  bool isSelected = false;


  CartaWidget(this.card, this.x, this.y, this.isHidden): super(size: isHidden ? Vector2(64, 85) : Vector2.all(64), position: Vector2(x, y)){

  }

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
      final Rect bounds = Rect.fromLTWH(0, 0, 65, 85);
      final Paint paint = Paint()
        ..color = CardColor.toFlutterColor(card.color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(5.0));
      canvas.drawRRect(roundedRect, paint);


      final Paint paintBlack = Paint()
        ..color = Colors.black;
      final Rect boundsBlack = Rect.fromLTWH(0, 64, 64.5, 20);
      final RRect roundedRectBlack = RRect.fromRectAndRadius(boundsBlack, Radius.circular(5.0));

      canvas.drawRRect(roundedRectBlack, paintBlack);

      // Dibuja valores de ataque y vida
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${this.card.attackPoints} | ${this.card.healthPoints}',
          style: TextStyle(color: Colors.white, backgroundColor: Colors.black),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(15, 65));
    }




/*      final effect = ColorEffect(
        Colors.yellow,
        EffectController(duration: 1.5),
        opacityFrom: 0.2,
        opacityTo: 0.8,
      );*/

/*      final Rect bounds = Rect.fromLTWH(-3, -3, 70, 91);
      final Paint paint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      final RRect roundedRect = RRect.fromRectAndRadius(bounds, Radius.circular(7.0));

      canvas.drawRRect(roundedRect, paint);*/


      /*final timer = Timer(
        100,
        repeat: true,
        onTick: () {
          print("llego");
          shapeComponent.paint.color = shapeComponent.paint.color.withOpacity(shapeComponent.paint.color.opacity == 0.0 ? 1.0 : 0.0);
          shapeComponent.update(1);
        },
      );*/




     /* if (timer.isRunning() && !shapeComponent.isMounted){
        add(shapeComponent);
      }*/
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

  //TODO: el efecto podría ser similar al que se usa en DW3
  // Eleva la carta hacia arriba
  // La rodea de un borde que titila amarillo
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    this.isSelected = !this.isSelected;

/*    final colorEffect = ColorEffect(
      Colors.blue,
      EffectController(
        duration: 1.5,
      ),
    );*/

    final moveEffect = MoveEffect.to(
      this.isSelected ? Vector2(this.x, this.y - 20) : Vector2(this.x, this.y),
      EffectController(
        duration: 0.1,
        curve: Curves.easeOut,
      ),
    );

    this.add(moveEffect);

    if (this.isSelected){
      final Rect bounds = Rect.fromLTWH(-3, -3, 70, 91);
      final Paint paint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      final shapeComponent = RectangleComponent.fromRect(bounds);
      shapeComponent.paint = paint;

      final effect = ColorEffect(
        Colors.green,
        EffectController(duration: 0.25, infinite: true, reverseDuration: 0.25),
        opacityFrom: 0.2,
        opacityTo: 0.8,
      );

      shapeComponent.add(effect);
      this.add(shapeComponent);
    }
    else{
      this.children.first.add(RemoveEffect(delay: 0.1));
    }

    this.update(1);


    /*final sizeEffectSelected = SizeEffect.to(
      this.isSelected ? Vector2(90, 80) : Vector2.all(64),
      EffectController(duration: 0.1),
    );

    this.add(sizeEffectSelected);*/
  }
}




