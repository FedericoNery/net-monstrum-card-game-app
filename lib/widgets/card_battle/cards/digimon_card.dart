import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/base_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

import '../../../domain/card/card_digimon.dart';
import '../effects/effects.dart';

class DigimonCardComponent extends BaseCardComponent
    with TapCallbacks, FlameBlocListenable<CardBattleBloc, CardBattleState> {
  final CardDigimon card;
  DigimonCardComponent(
      this.card, double x, double y, bool isHidden, bool isRival)
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
    final uri = isHidden
        ? 'cards/card_back4.webp'
        : 'digimon/${card.digimonName.replaceAll(" ", "-")}.jpg';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden) {
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);

      drawApHpTexts(canvas, card.attackPoints, card.healthPoints);
    }
  }

  @override
  void update(double dt) {
    // Implementa la lógica de actualización si es necesario
  }

  void reveal() async {
    final sizeEffect = SizeEffect.to(
      Vector2(1, 85),
      EffectController(duration: 0.3, curve: Curves.easeInOut),
    );

    add(sizeEffect);
    sizeEffect.onComplete = () async {
      isHidden = false;
      size = Vector2.all(64);
      final uri = 'digimon/${card.digimonName.replaceAll(" ", "-")}.jpg';
      sprite = await Sprite.load(uri);
      update(1);
    };
  }

  bool isEnabledToEquip() {
    return bloc.state.battleCardGame.isUpgradePhase();
  }

  bool isEnabledToSummonDigimonCard(int internalCardId) {
    return bloc.state.battleCardGame.isSummonPhase() &&
        bloc.state.battleCardGame.player.hand
            .isDigimonCardByInternalId(internalCardId);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    bool isEnabledToSelect = isEnabledToSummonDigimonCard(card.uniqueIdInGame!);
    bool isEnabledToBeEquipped = isEnabledToEquip();

    //TODO :: ver si conviene renderizar o utilizar otra clase para la carta rival
    if (isEnabledToSelect && !isRival) {
      isSelected = !isSelected;

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected) {
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
      } else {
        children.first.add(RemoveEffect(delay: 0.1));
      }

      if (bloc.state.battleCardGame.player
          .hasSufficientEnergiesToSummonCard(card)) {
        bloc.add(SelectDigimonCardFromHandToSummon(card.uniqueIdInGame!));
      }

      update(1);
    }

    if (isEnabledToBeEquipped) {
      //targetOfEquipment(card.internalGameId);
      bloc.add(SelectDigimonCardToBeEquipped(card.uniqueIdInGame!));
    }
  }

  @override
  void onNewState(CardBattleState state) {}

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
