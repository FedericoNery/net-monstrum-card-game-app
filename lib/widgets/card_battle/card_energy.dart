import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';
import 'effects/effects.dart';
import './card_widget_base.dart';

class CardEnergyWidget extends CardWidget with TapCallbacks {
  final CardEnergy card;
  Function activateEnergy = () => {};

  CardEnergyWidget(this.card, x, y, isHidden, isRival, internalCardId, isEnabledToSelectCard, activateEnergy):
        super(
        size: isHidden ? Vector2(64, 85) : Vector2.all(64),
        position: Vector2(x, y),
      ){
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.x = x;
    this.y = y;
    this.internalCardId = internalCardId;
    this.isEnabledToSelectCard = isEnabledToSelectCard;
    this.activateEnergy = activateEnergy;
  }

  @override
  Future<void> onLoad() async {
    final uri = isHidden ? 'cards/card_back4.webp' : 'energies/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden){
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);
      drawEquipmentText(canvas, " (NRG) ");
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
    final uri = 'energies/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // && !isRival
    //TODO :: TEMPORAL
    if(isEnabledToSelectCard(card.internalGameId) && !isRival){
      super.onTapDown(event);
      isSelected = !isSelected;
      //callbackSelectCardFromHand(card.internalGameId);
      //callbackActivateEquipment(card.internalGameId, card);

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected){
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
        activateEnergy(card.internalGameId, card);
      }
      else{
        children.first.add(RemoveEffect(delay: 0.1));
      }

      update(1);
    }
  }
}