import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/screens/card_battle_component.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';

class SinglePlayerGameView extends StatelessWidget {
  const SinglePlayerGameView({super.key});

  @override
  Widget build(BuildContext context) {
    AggregationService service = AggregationService();
    Aggregation player = service.getAggregatioByUserId(1);
    Aggregation rival = service.getAggregatioByUserId(2);

    Tamer playerTamer =
        Tamer(player.decksAggregations[0].cards, player.user.username);
    Tamer rivalTamer =
        Tamer(rival.decksAggregations[0].cards, rival.user.username);
    BattleCardGame battleCardGame = BattleCardGame(playerTamer, rivalTamer);
    CardBattleComponent game = CardBattleComponent(battleCardGame);

    return GameWidget(game: game);
  }
}
