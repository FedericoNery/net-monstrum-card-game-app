import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/views/card_battle_multiplayer_view.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WaitingRoom extends StatefulWidget {
  final String gameId;
  final String socketId;
  WaitingRoom({required this.gameId, required this.socketId});

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
      Map<String, dynamic> objetoDeserializado = json.decode(data);
      print(data);

/*       Tamer playerTamer =
          Tamer(player.decksAggregations[0].cards, player.user.username);
      Tamer rivalTamer =
          Tamer(rival.decksAggregations[0].cards, rival.user.username);
      BattleCardGame battleCardGame = BattleCardGame(playerTamer, rivalTamer); */

      print(data);
      /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CardBattleMultiplayerView(battleCardGame))); */
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
