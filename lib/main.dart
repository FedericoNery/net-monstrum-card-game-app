import 'dart:convert';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';

import 'screens/card_battle.dart';
import 'screens/card_battle_component.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

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

class SocketView extends StatelessWidget {
  const SocketView({super.key});

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  GameView cardBattleWidget = GameView();
  runApp(cardBattleWidget);

  /*  SocketView socketView = SocketView();
  runApp(socketView); */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListRoomsPage(title: 'Flutter Demo Home Page'),
    );
  }
}
