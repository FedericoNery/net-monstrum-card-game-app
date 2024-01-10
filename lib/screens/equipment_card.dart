import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card-equipment.dart';
import 'package:net_monstrum_card_game/domain/color.dart';
import 'package:net_monstrum_card_game/screens/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/screens/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/screens/styles/flickering_card_border.dart';
import 'effects/effects.dart';
import 'package:net_monstrum_card_game/screens/card_widget_base.dart';

class CardEquipmentWidget extends CardWidget with TapCallbacks {
  final CardEquipment card;

  CardEquipmentWidget(this.card, x, y, isHidden, callbackSelectCardFromHand, indexCard, isRival):
        super(
          size: isHidden ? Vector2(64, 85) : Vector2.all(64),
          position: Vector2(x, y),
      ){
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.indexCard = indexCard;
    this.callbackSelectCardFromHand = callbackSelectCardFromHand;
    this.x = x;
    this.y = y;
  }

  @override
  Future<void> onLoad() async {
    print(this.isHidden);
    final uri = this.isHidden ? 'cards/card_back4.webp' : 'equipments/${this.card.name}.jpg';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!this.isHidden){
      drawCardColor(canvas, CardColor.EQUIPMENT);
      drawBackgroundApHp(canvas);
      drawApHpTexts(canvas, this.card.attackPoints, this.card.healthPoints);

    }
  }

  @override
  void update(double dt) {
  }

  @override
  void reveal() async{
    if (this.isRival){
      this.size = Vector2.all(64);
    }
    this.isHidden = false;
    final uri = 'equipments/${this.card.name}.jpg';
    this.sprite = await Sprite.load(uri);
  }

  @override
  void onTapDown(TapDownEvent event) {
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