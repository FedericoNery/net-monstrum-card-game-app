import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/screens/card_battle.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/shared/background_image.dart';

class CardBattleComponent extends FlameGame
{
  final BattleCardGame battleCardGame;
  final _imagesNames = [ParallaxImageData("backgrounds/fondo5.jpeg")];
  CardBattleComponent(this.battleCardGame);

  @override
  Future<void> onLoad() async {
    final parallax = await loadParallaxComponent(
      _imagesNames,
      baseVelocity: Vector2(30,-20),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      filterQuality: FilterQuality.none,
      repeat: ImageRepeat.repeat
    );
    add(parallax);

    await add(
      FlameBlocProvider<CardBattleBloc, CardBattleState>(
        create: () => CardBattleBloc(battleCardGame),
        children: [
          CardBattle()
        ],
      )
    );
  }
}