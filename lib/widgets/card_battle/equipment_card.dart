import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';
import 'effects/effects.dart';
import './card_widget_base.dart';

class CardEquipmentWidget extends CardWidget with TapCallbacks {
  final CardEquipment card;
  Function callbackActivateEquipment = (int index, CardEquipment cardEquipment) => {};

  CardEquipmentWidget(this.card, x, y, isHidden, callbackSelectCardFromHand, isRival, isEnabledToSelectCard, activateEquipment, internalCardId):
        super(
          size: isHidden ? Vector2(64, 85) : Vector2.all(64),
          position: Vector2(x, y),
      ){
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.callbackSelectCardFromHand = callbackSelectCardFromHand;
    this.isEnabledToSelectCard = isEnabledToSelectCard;
    callbackActivateEquipment = activateEquipment;
    this.x = x;
    this.y = y;
    this.internalCardId = internalCardId;
  }

  @override
  Future<void> onLoad() async {
    final uri = isHidden ? 'cards/card_back4.webp' : 'equipments/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden){
      drawCardColor(canvas, CardColor.EQUIPMENT);
      drawBackgroundApHp(canvas);
      drawEquipmentText(canvas, " (E) ");
    }
  }

  @override
  void update(double dt) {
  }

  @override
  void reveal() async{
    if (isRival){
      size = Vector2.all(64);
    }
    isHidden = false;
    final uri = 'equipments/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(isEnabledToSelectCard(card.internalGameId) && !isRival){
      super.onTapDown(event);
      isSelected = !isSelected;
      callbackSelectCardFromHand(card.internalGameId);
      callbackActivateEquipment(card.internalGameId, card);

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
  }
}