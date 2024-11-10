import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/card_battle_component_multiplayer.dart';
import 'package:net_monstrum_card_game/views/menu.dart';

class CardBattleMultiplayerView extends StatelessWidget {
  // Agregar variable para deserializar el juego desde socket io
  BattleCardGame battleCardGame;
  CardBattleMultiplayerView({super.key, required this.battleCardGame});

  @override
  Widget build(BuildContext context) {
    CardBattleComponentMultiplayer game = CardBattleComponentMultiplayer(
        battleCardGame, () => redirectToHomePage(context));

    return Scaffold(body: GameWidget(game: game));
  }

  void redirectToHomePage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
    );
  }
}
