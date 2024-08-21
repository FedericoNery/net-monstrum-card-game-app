import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/base_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

class EnergyCardComponent extends BaseCardComponent
    with
        TapCallbacks,
        FlameBlocListenable<CardBattleMultiplayerBloc,
            CardBattleMultiplayerState> {
  final CardEnergy card;
  EnergyCardComponent(this.card, x, y, isHidden, isRival)
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
        isHidden ? 'cards/card_back4.webp' : 'energies/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden) {
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);
      drawEquipmentText(canvas, " (NRG) ");
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
      final uri = 'energies/${card.name}.png';
      sprite = await Sprite.load(uri);
      update(1);
    };
  }

  @override
  void onTapDown(TapDownEvent event) async {
    super.onTapDown(event);
    //TODO :: TEMPORAL
    if (isEnabledToSelectEnergyCard(card.uniqueIdInGame!) && !isRival) {
      isSelected = !isSelected;

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected) {
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
        removeFromParent();
      } else {
        children.first.add(RemoveEffect(delay: 0.1));
      }

      //bloc.add(ActivateEnergyCard(card));
    }
  }

  bool isEnabledToSelectEnergyCard(int internalCardId) {
    return bloc.state.battleCardGame.isCompilationPhase() &&
        bloc.state.battleCardGame.player.hand
            .isEnergyCardByInternalId(internalCardId);
  }

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
