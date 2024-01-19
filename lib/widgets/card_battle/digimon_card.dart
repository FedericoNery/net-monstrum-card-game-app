import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

import '../../domain/card/card_digimon.dart';
import 'effects/effects.dart';
import './card_widget_base.dart';

class CardDigimonWidget extends CardWidget with TapCallbacks {
  final CardDigimon card;
  Function targetOfEquipment = () => {};
  Function isEnabledToBeEquip = () => {};

  CardDigimonWidget(this.card, double x, double y, bool isHidden, callbackSelectCardFromHand, bool isRival, isEnabledToSelectCard, this.targetOfEquipment, this.isEnabledToBeEquip, int internalCardId):
        super(
        size: isHidden ? Vector2(64, 85) : Vector2.all(64),
        position: Vector2(x, y),
      ) {
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.callbackSelectCardFromHand = callbackSelectCardFromHand;
    this.isEnabledToSelectCard = isEnabledToSelectCard;
    this.x = x;
    this.y = y;
    this.internalCardId = internalCardId;
  }

  @override
  Future<void> onLoad() async {
    final uri = isHidden ? 'cards/card_back4.webp' : 'digimon/${card.digimonName}.jpg';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden){
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);

      drawApHpTexts(canvas, card.attackPoints, card.healthPoints);

    }
  }

  @override
  void update(double dt) {
    // Implementa la lógica de actualización si es necesario
  }

  void reveal() async{
    if (isRival){
      size = Vector2.all(64);
    }
    isHidden = false;
    final uri = 'digimon/${card.digimonName}.jpg';
    sprite = await Sprite.load(uri);
  }

  @override
  void onTapDown(TapDownEvent event) {
    //TODO :: ver si conviene renderizar o utilizar otra clase para la carta rival
    if(isEnabledToSelectCard(card.internalGameId) && !isRival){
      super.onTapDown(event);
      isSelected = !isSelected;
      callbackSelectCardFromHand(card.internalGameId);

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected){
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
      }
      else{
        children.first.add(RemoveEffect(delay: 0.1));
      }

      update(1);
    }

    if(isEnabledToBeEquip()){
      targetOfEquipment(card.internalGameId);
    }
  }
}




