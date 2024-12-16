import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/card_battle_multiplayer.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/base_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../domain/card/card_digimon.dart';

class DigimonCardComponent extends BaseCardComponent<CardDigimon>
    with
        TapCallbacks,
        CollisionCallbacks,
        HasWorldReference<CardBattleMultiplayer>,
        FlameBlocListenable<CardBattleMultiplayerBloc,
            CardBattleMultiplayerState> {
  late int rowId;
  late bool isAttacking;

  DigimonCardComponent(
      CardDigimon cardDigimon, double x, double y, bool isHidden, bool isRival)
      : super(
          size: isHidden ? Vector2(64, 85) : Vector2.all(64),
          position: Vector2(x, y),
        ) {
    this.isHidden = isHidden;
    this.isRival = isRival;
    this.x = x;
    this.y = y;
    this.card = cardDigimon;
    this.rowId = isRival ? 1 : 2;
    this.isAttacking = false;
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    final uri = isHidden
        ? 'cards/card_back4.webp'
        : 'digimon/${card.digimonName.replaceAll(' ', '-')}.jpg';
    sprite = await Sprite.load(uri);

    if (isRival) {
      final xHitboxOrigin = 100.0 - x;
      final yHitboxOrigin = 35.0 - y;
      add(RectangleHitbox(
          position: Vector2(xHitboxOrigin, yHitboxOrigin),
          size: Vector2(520, 85),
          isSolid: true));
    }
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    if (!isHidden) {
      drawCardColor(canvas, card.color);
      drawBackgroundApHp(canvas);

      drawApHpTexts(canvas, card.currentAttackPoints, card.currentHealthPoints);
    }
  }

  @override
  void update(double dt) {
    // Implementa la lógica de actualización si es necesario
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print(bloc.state.battleCardGame.phaseGame);
    if (other is DigimonCardComponent &&
        bloc.state.battleCardGame.isBattlePhase()) {
      if (other.isAttacking && !isAttacking && other.rowId != this.rowId) {
        handleCollision();
      }
    }
  }

  void handleCollision() {
    rotateAndApplyLightning();
  }

  void rotateAndApplyLightning() {
    final rotateEffect = RotateEffect.by(
      0.1, // Ángulo en radianes (positivo o negativo)
      EffectController(duration: 0.2, reverseDuration: 0.2), // Rotar y volver
    );
    position = Vector2(x + 32, y + 32);
    anchor = Anchor.center;
    add(rotateEffect);
    applyLightningEffect();
  }

  void applyLightningEffect() async {
    final lightningSprite = SpriteComponent()
      ..sprite =
          await Sprite.load('effects/lightning-2.png') // Tu imagen de rayos
      ..size = size // Ajustar al tamaño de la carta
      ..position = Vector2(32, 30) // Coincidir con la posición de la carta
      ..anchor = Anchor.center;

    add(lightningSprite);

    // Remover el efecto después de un tiempo
    Future.delayed(Duration(milliseconds: 300), () {
      lightningSprite.removeFromParent();
    });
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

    if (!isRival) {
      final xHitboxOrigin = 100.0 - x;
      final yHitboxOrigin = 278.5 - y;
      add(RectangleHitbox(
          position: Vector2(xHitboxOrigin, yHitboxOrigin),
          size: Vector2(520, 85),
          isSolid: true));
    }
  }

  bool isEnabledToEquip(int internalCardId) {
    return bloc.state.battleCardGame.isUpgradePhase() &&
        bloc.state.battleCardGame.player.digimonZone
            .isDigimonCardByInternalId(internalCardId);
  }

  bool isEnabledToSummonDigimonCard(int internalCardId) {
    return bloc.state.battleCardGame.isSummonPhase() &&
        bloc.state.battleCardGame.player.hand
            .isDigimonCardByInternalId(internalCardId);
  }

  void attackAnimation() async {
    isAttacking = true;
    final scaleEffectUp = ScaleEffect.to(
      Vector2.all(1.5),
      EffectController(duration: 0.15, startDelay: 0.05),
    );

    final attackPathEffect = MoveAlongPathEffect(
      Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(30, isRival ? 100 : -80, 0, isRival ? 200 : -180),
      EffectController(duration: 0.3),
    );

    final returnPathEffect = MoveAlongPathEffect(
      Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(30, isRival ? -100 : 80, 0, isRival ? -200 : 180),
      EffectController(duration: 0.3),
    );

    final scaleEffectDown = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: 0.15, startDelay: 0.05),
    );

    add(attackPathEffect);
    add(scaleEffectUp);

    attackPathEffect.onComplete = () {
      add(scaleEffectDown);
      add(returnPathEffect);
    };

    returnPathEffect.onComplete = () {
      isAttacking = false;
    };
  }

  @override
  void onTapDown(TapDownEvent event) {
    IO.Socket socket = SocketManager().socket!;
    super.onTapDown(event);
    bool isEnabledToSelectAndIsSummonPhase =
        isEnabledToSummonDigimonCard(card.uniqueIdInGame!);
    bool isEnabledToBeEquipped = isEnabledToEquip(card.uniqueIdInGame!);

    //TODO :: ver si conviene renderizar o utilizar otra clase para la carta rival
    if (isEnabledToSelectAndIsSummonPhase && !isRival) {
      isSelected = !isSelected;

      final moveEffect = getUpAndDownEffect(isSelected, x, y);
      add(moveEffect);

      if (isSelected) {
        add(super.shapeComponent);
      } else {
        remove(super.shapeComponent);
        //children.first.add(RemoveEffect(delay: 0.1));
      }

      if (bloc.state.battleCardGame.player
          .hasSufficientEnergiesToSummonCard(card)) {
        bloc.add(SelectDigimonCardFromHandToSummon(card.uniqueIdInGame!));
      }

      if (isSelected &&
          !bloc.state.battleCardGame.player
              .hasSufficientEnergiesToSummonCard(card)) {
        bloc.add(LogAction("No hay suficientes energias"));
      }

      update(1);
    }

    if (isEnabledToBeEquipped) {
      //TAL VEZ NO SEA NECESARIO ESTE EVENTO
      //bloc.add(SelectDigimonCardToBeEquipped(card.uniqueIdInGame!));
      socket.emit('activateEquipmentCard', {
        "cardDigimonId": card.uniqueIdInGame,
        "cardEquipmentId":
            bloc.state.battleCardGame.player.selectedEquipmentCardId!,
        "userId": bloc.state.battleCardGame.player.username,
        "socketId": socket.id
      });
      bloc.add(LogAction("${card.digimonName} fue equipado"));
    }
  }

/*   @override
  void onNewState(CardBattleState state) {} */

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
