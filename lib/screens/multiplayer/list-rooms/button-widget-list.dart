import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/adapters/list_card_adapter.dart';
import 'package:net_monstrum_card_game/communication/socket_events_names.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/views/card_battle_multiplayer_view.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_common/src/util/event_emitter.dart';

class MyButtonListWidget extends StatefulWidget {
  List<String> roomsIds;
  Function onNavigation;

  MyButtonListWidget({required this.roomsIds, required this.onNavigation});

  @override
  _MyButtonListWidgetState createState() => _MyButtonListWidgetState();
}

class _MyButtonListWidgetState extends State<MyButtonListWidget> {
  IO.Socket socket = SocketManager().socket!;

  _MyButtonListWidgetState() {
    socket.on(
        ServerActions.START_GAME,
        (data) {
          var jsonMap = json.decode(data);
          Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);
          BattleCardGame battleCardGame;
          var playerCards =
              flutterMap["gameData"]["game"]["field1"]["deck"]["cartas"];

          String playerInfo =
              flutterMap["gameData"]["game"]["player1"]["username"];

          var rivalCards =
              flutterMap["gameData"]["game"]["field2"]["deck"]["cartas"];
          String rivalInfo =
              flutterMap["gameData"]["game"]["player2"]["username"];

          Tamer playerTamer = Tamer(
              ListCardAdapter.getListOfCardsInstantiated(playerCards),
              playerInfo);
          Tamer rivalTamer = Tamer(
              ListCardAdapter.getListOfCardsInstantiated(rivalCards),
              rivalInfo);

          battleCardGame = BattleCardGame(playerTamer, rivalTamer);

          /* if (socket.id! == flutterMap["gameData"]["socketIdUsuarioA"]) {
          } else {
            battleCardGame = BattleCardGame(rivalTamer, playerTamer);
          } */
          widget.onNavigation(battleCardGame);
          //Convertir a BattleCardGame o delegarlo en el otro componente
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => CardBattleMultiplayerView(
                      battleCardGame: battleCardGame,
                    )),
            (Route<dynamic> route) => true,
          ); */
        } as EventHandler);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roomsIds.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.roomsIds.length,
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            onPressed: () {
              AggregationService service = AggregationService();
              Aggregation player = service.getAggregatioByUserId(2);

              String roomId = widget.roomsIds[index];
              socket.emit('playerJoinGame', {
                "deck": player.decksAggregations[0].cards,
                "user": {
                  "id": player.user.id,
                  "username": player.user.username
                },
                "gameIdToJoin": roomId,
                "socketId": socket.id!
              });
            },
            child: Text(widget.roomsIds[index]),
          );
        },
      );
    }

    return const Text('No hay salas creadas');
  }
}
