import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms.dart';

class MultiplayerGameView extends StatelessWidget {
  MultiplayerGameView({super.key});
/* 
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
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListRoomsPage(title: 'List Rooms Page'),
    );
  }
}
