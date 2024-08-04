import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/screens/card_battle_component_multiplayer.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';

class CardBattleMultiplayerView extends StatelessWidget {
  // Agregar variable para deserializar el juego desde socket io
  BattleCardGame battleCardGame;
  CardBattleMultiplayerView({super.key, required this.battleCardGame});

  @override
  Widget build(BuildContext context) {
    CardBattleComponentMultiplayer game =
        CardBattleComponentMultiplayer(battleCardGame);

    return GameWidget(game: game);
  }
}
