import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/card_battle.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_state.dart';

class CardBattleComponent extends FlameGame {
  final BattleCardGame battleCardGame;

  CardBattleComponent(this.battleCardGame)
      : super(
          camera: CameraComponent.withFixedResolution(width: 850, height: 400),
        );

  @override
  Future<void> onLoad() async {
    final backgroundImage = await images.load("backgrounds/fondo5.jpeg");
    final _imagesNames = [ParallaxImageData("backgrounds/fondo5-min.jpeg")];

    final screenSize = WidgetsBinding.instance!.window.physicalSize;

    final scaleX = screenSize.width / 850; //backgroundImage.width;
    final scaleY = screenSize.height / 500; //backgroundImage.height;

    final parallax = await loadParallaxComponent(_imagesNames,
        baseVelocity: Vector2(30, -20),
        velocityMultiplierDelta: Vector2(1.8, 1.0),
        filterQuality: FilterQuality.none,
        repeat: ImageRepeat.repeat,
        scale: Vector2(scaleX, scaleY));
    add(parallax);
    world = CardBattle(scaleX); //screenSizeWidth
    camera.world = world;
    camera.moveTo(Vector2(400, 200));
    await add(FlameBlocProvider<CardBattleBloc, CardBattleState>(
      create: () => CardBattleBloc(battleCardGame),
      children: [world],
    ));
  }
}
