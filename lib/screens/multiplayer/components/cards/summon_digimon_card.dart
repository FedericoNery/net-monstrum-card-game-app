import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/base_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SummonDigimonCardComponent extends BaseCardComponent<CardSummonDigimon>
    with
        TapCallbacks,
        FlameBlocListenable<CardBattleMultiplayerBloc,
            CardBattleMultiplayerState> {
  SummonDigimonCardComponent(
      CardSummonDigimon cardSummonDigimon, x, y, isHidden, isRival)
      : super(
          size: isHidden ? Vector2(64, 85) : Vector2.all(64),
          position: Vector2(x, y),
        ) {
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.x = x;
    this.y = y;
    this.card = cardSummonDigimon;
  }

  @override
  Future<void> onLoad() async {
    final uri =
        isHidden ? 'cards/card_back4.webp' : 'summon_digimon/${card.name}.png';
    sprite = await Sprite.load(uri);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden) {
      drawCardColor(canvas, CardColor.SUMMON);
      drawBackgroundApHp(canvas);
      drawEquipmentText(canvas, "(SUM)");
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
      final uri = 'summon_digimon/${card.name}.png';
      sprite = await Sprite.load(uri);
      update(1);
    };
  }

  @override
  void onTapDown(TapDownEvent event) async {
    IO.Socket socket = SocketManager().socket!;

    super.onTapDown(event);
    //TODO :: TEMPORAL
    if (isEnabledToSelectSummonDigimonCard(card.uniqueIdInGame!) && !isRival) {
      isSelected = !isSelected;

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected) {
        final shapeComponent = getFlickeringCardBorder();
        add(shapeComponent);
        socket.emit('activateSummonDigimonCard', {
          "cardId": card.uniqueIdInGame,
          "userId": bloc.state.battleCardGame.player.username,
          "socketId": socket.id
        });
        removeFromParent();
      } else {
        children.first.add(RemoveEffect(delay: 0.1));
      }

      //bloc.add(ActivateSummonDigimonCard(card));
    }
  }

  bool isEnabledToSelectSummonDigimonCard(int internalCardId) {
    return bloc.state.battleCardGame.isUpgradePhase() &&
        bloc.state.battleCardGame.player.hand
            .isSummonDigimonCardByInternalId(internalCardId);
  }

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
