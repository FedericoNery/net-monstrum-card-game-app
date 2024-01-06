import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/color.dart';
import 'package:net_monstrum_card_game/domain/card.dart' as CardPackage;
import 'package:net_monstrum_card_game/screens/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/screens/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/screens/styles/flickering_card_border.dart';

import 'effects/effects.dart';

class CartaWidget extends SpriteComponent with TapCallbacks {
  final CardPackage.Card card;
  final double x;
  final double y;
  bool isHidden = false;
  bool isSelected = false;
  bool isRival = false;
  Function callbackSelectCardFromHand;
  int indexCard;

  CartaWidget(this.card, this.x, this.y, this.isHidden, this.callbackSelectCardFromHand, this.indexCard, this.isRival): super(size: isHidden ? Vector2(64, 85) : Vector2.all(64), position: Vector2(x, y)){

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
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);

      drawApHpTexts(canvas, this.card.attackPoints, this.card.healthPoints);

    }
  }

  @override
  void update(double dt) {
    // Implementa la lógica de actualización si es necesario
  }

  void reveal() async{
    if (this.isRival){
      this.size = Vector2.all(64);
    }
    this.isHidden = false;
    final uri = 'digimon/${this.card.digimonName}.jpg';
    this.sprite = await Sprite.load(uri);
  }

  @override
  void onTapDown(TapDownEvent event) {
    //TODO :: ver si conviene renderizar o utilizar otra clase para la carta rival
    if(!this.isRival){
      super.onTapDown(event);
      this.isSelected = !this.isSelected;
      this.callbackSelectCardFromHand(this.indexCard);

      final moveEffect = getUpAndDownEffect(this.isSelected, this.x, this.y);
      this.add(moveEffect);

      if (this.isSelected){
        final shapeComponent = getFlickeringCardBorder();
        this.add(shapeComponent);
      }
      else{
        this.children.first.add(RemoveEffect(delay: 0.1));
      }

      this.update(1);
    }
  }
}




