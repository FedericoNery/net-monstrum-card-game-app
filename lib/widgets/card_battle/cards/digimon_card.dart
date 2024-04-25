import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/base_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/ap_hp_texts.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/card_color_border.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

import '../../../domain/card/card_digimon.dart';
import '../effects/effects.dart';

class DigimonCardComponent extends BaseCardComponent
    with TapCallbacks, CollisionCallbacks, FlameBlocListenable<CardBattleBloc, CardBattleState> {
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
    final uri =
        isHidden ? 'cards/card_back4.webp' : 'digimon/${card.digimonName}.jpg';
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

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {
      //...
    } else if (other is DigimonCardComponent) {
      //...
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is ScreenHitbox) {
      //...
    } else if (other is DigimonCardComponent) {
      //...
    }
  }

  void reveal() async {
    isHidden = false;
    size = Vector2.all(64);
    final uri = 'digimon/${card.digimonName}.jpg';
    sprite = await Sprite.load(uri);
    update(1);
  }

  void attack() {
    /* final attackMove = MoveEffect.to(
      Vector2(380, 50),
      EffectController(
        duration: 3,
        reverseDuration: 1,
        infinite: false,
        curve: Curves.easeOut,
      ),
    ); */

    final moveEffectToAttack = MoveAlongPathEffect(
      Path()..quadraticBezierTo(0, 100, isRival ? 200 : -200, isRival ? 200 : -100),
      EffectController(duration: 1.0),
    );

    final moveEffectToOriginalPosition = MoveAlongPathEffect(
      Path()..quadraticBezierTo(0, -100, isRival ? -200 : 200, isRival ? -200 : 100),
      EffectController(duration: 1.0),
    );

    final scaleToAttack = ScaleEffect.to(
        Vector2.all(1.3),
        EffectController(
          duration: 0.4,
          curve: Curves.easeOut,
        ),
      );

    final scaleToOriginalSize = ScaleEffect.to(
        Vector2.all(1),
        EffectController(
          duration: 0.4,
          curve: Curves.easeOut,
        ),
      );

    scaleToAttack.onComplete = () {
      add(scaleToOriginalSize);
        //add(RemoveEffect(delay: 0.0));
    };

    moveEffectToAttack.onComplete = () {
      add(moveEffectToOriginalPosition);
    };

    add(moveEffectToAttack);
    add(scaleToAttack);

  }

  void receiveDamage() async {
    final rayoImage = await Flame.images.load('rayo1.png');
    final rayo = SpriteComponent.fromImage(rayoImage);
    rayo.scale = Vector2(60 / rayoImage.width, 84 / rayoImage.height);
    rayo.position = Vector2(150, 50);
    final paint = Paint()..color = const Color(0xff39FF14);
    rayo.paint = paint;
    rayo.add(GlowEffect(
      10.0,
      EffectController(duration: 1),    
    ));
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

      bloc.add(SelectDigimonCardFromHandToSummon(card.uniqueIdInGame!));

      update(1);
    }

    if (isEnabledToBeEquipped) {
      //targetOfEquipment(card.internalGameId);
      bloc.add(SelectDigimonCardToBeEquipped(card.uniqueIdInGame!));
    }
  }

  @override
  void onNewState(CardBattleState state) {

  }

  @override
  int getUniqueCardId() {
    return card.uniqueIdInGame!;
  }
}
