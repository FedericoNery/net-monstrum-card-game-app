import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/adapters/list_card_adapter.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/views/card_battle_multiplayer_view.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WaitingRoom extends StatefulWidget {
  final String gameId;
  final _mainNavigatorKey = GlobalKey<NavigatorState>();
  final String socketId;
  Function onNavigation;

  WaitingRoom(
      {required this.gameId,
      required this.socketId,
      required this.onNavigation});

  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  IO.Socket socket = SocketManager().socket!;

  @override
  void initState() {
    super.initState();
    print("ENTROOOO");
    socket.on('start game', (data) {
      var jsonMap = json.decode(data);
      Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);

      var playerCards =
          flutterMap["gameData"]["game"]["field2"]["deck"]["cartas"];

      String playerInfo = flutterMap["gameData"]["game"]["player2"]["username"];

      var rivalCards =
          flutterMap["gameData"]["game"]["field1"]["deck"]["cartas"];

      String rivalInfo = flutterMap["gameData"]["game"]["player1"]["username"];

      Tamer playerTamer = Tamer(
          ListCardAdapter.getListOfCardsInstantiated(playerCards), playerInfo);
      Tamer rivalTamer = Tamer(
          ListCardAdapter.getListOfCardsInstantiated(rivalCards), rivalInfo);

      BattleCardGame battleCardGame = BattleCardGame(playerTamer, rivalTamer);

      //Navigator.push(

      widget.onNavigation(battleCardGame);

      /* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => CardBattleMultiplayerView(
                  battleCardGame: battleCardGame,
                )),
        (Route<dynamic> route) => true,
      ); */
    });
  }

  @override
  void dispose() {
    //socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esperando que se conecte un rival'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
