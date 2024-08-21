import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/base_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

class CardEquipmentWidget extends BaseCardComponent
    with
        TapCallbacks,
        FlameBlocListenable<CardBattleMultiplayerBloc,
            CardBattleMultiplayerState> {
  final CardEquipment card;

  CardEquipmentWidget(this.card, x, y, isHidden, isRival)
      : super(
          size: isHidden ? Vector2(64, 85) : Vector2.all(64),
          position: Vector2(x, y),
        ) {
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.x = x;
    this.y = y;
  }

  @override
  Future<void> onLoad() async {
    final uri =
        isHidden ? 'cards/card_back4.webp' : 'equipments/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden) {
      drawCardColor(canvas, CardColor.EQUIPMENT);
      drawBackgroundApHp(canvas);
      drawEquipmentText(canvas, " (EQG) ");
    }
  }

  @override
  void update(double dt) {}

  @override
  void reveal() async {
    final sizeEffect = SizeEffect.to(
      Vector2(1, 85),
      EffectController(duration: 0.3, curve: Curves.easeInOut),
    );

    add(sizeEffect);
    sizeEffect.onComplete = () async {
      size = Vector2.all(64);
      isHidden = false;
      final uri = 'equipments/${card.name}.png';
      sprite = await Sprite.load(uri);
      update(1);
    };
  }

  bool isEnabledToSelectCard(int internalCardId) {
    return bloc.state.battleCardGame.isUpgradePhase() &&
        bloc.state.battleCardGame.player.hand
            .isEquipmentCardByInternalId(internalCardId);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (isEnabledToSelectCard(card.uniqueIdInGame!) && !isRival) {
      isSelected = !isSelected;
      //callbackSelectCardFromHand(card.internalGameId);
      //callbackActivateEquipment(card.internalGameId, card);

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected) {
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
      } else {
        children.first.add(RemoveEffect(delay: 0.1));
      }

      //bloc.add(SelectEquipmentCardFromHandTo(card));
      update(1);
    }
  }

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
