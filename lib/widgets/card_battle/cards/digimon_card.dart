import 'dart:ui';
import 'package:flame/collisions.dart';
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
    with
        TapCallbacks,
        CollisionCallbacks,
        FlameBlocListenable<CardBattleBloc, CardBattleState> {
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
    add(RectangleHitbox(
        position: Vector2(x, y), size: Vector2(400, 80), isSolid: true));
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Comprobar si colisiona con otra carta
    print("ENTRO");
    if (other is DigimonCardComponent) {
      handleCollision();
    }
  }

  void handleCollision() {
    // Lógica cuando colisiona con otra carta
    rotateAndApplyLightning();
  }

  void rotateAndApplyLightning() {
    final rotateEffect = RotateEffect.by(
      0.1, // Ángulo en radianes (positivo o negativo)
      EffectController(duration: 0.2, reverseDuration: 0.2), // Rotar y volver
    );

    add(rotateEffect);
    applyLightningEffect();
  }

  void applyLightningEffect() async {
    final lightningSprite = SpriteComponent()
      ..sprite =
          await Sprite.load('effects/lightning-2.png') // Tu imagen de rayos
      ..size = size // Ajustar al tamaño de la carta
      ..position = Vector2.zero() // Coincidir con la posición de la carta
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
  }

  /*  void attackAnimation() async {
    final scaleEffectUp = ScaleEffect.to(
      Vector2.all(1.5),
      EffectController(duration: 0.15),
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
      EffectController(duration: 0.15),
    );

    add(scaleEffectUp);
    scaleEffectUp.onComplete = () {
      add(attackPathEffect);
    };

    attackPathEffect.onComplete = () {
      add(returnPathEffect);
    };

    returnPathEffect.onComplete = () {
      add(scaleEffectDown);
    };
  } */
  void attackAnimation() async {
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
        add(super.shapeComponent);
      } else {
        remove(super.shapeComponent);
        //children.first.add(RemoveEffect(delay: 0.1));
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
  void onNewState(CardBattleState state) {
    /* print(state.battleCardGame.isUpgradePhase());
    print(children.first.isMounted); */

    /* if (state.battleCardGame.isUpgradePhase() && shapeComponent.isMounted) {
      children.first.add(RemoveEffect(delay: 0.1));
    } */
  }

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
