import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/screens/card_battle.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';

class CardBattleComponent extends FlameGame
{
  final BattleCardGame battleCardGame;
  CardBattleComponent(this.battleCardGame);

  @override
  Future<void> onLoad() async {
    await add(
      FlameBlocProvider<CardBattleBloc, CardBattleState>(
        create: () => CardBattleBloc(battleCardGame),
        children: [
          CardBattle()
        ],
      )
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}