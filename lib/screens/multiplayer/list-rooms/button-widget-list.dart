import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/adapters/list_card_adapter.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/views/card_battle_multiplayer_view.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_common/src/util/event_emitter.dart';

import '../game/deck-selector.dart';

class MyButtonListWidget extends StatefulWidget {
  List<String> roomsIds; // Parámetro que se pasará al widget

  // Constructor que acepta el parámetro
  MyButtonListWidget({required this.roomsIds});

  @override
  _MyButtonListWidgetState createState() => _MyButtonListWidgetState();
}

class _MyButtonListWidgetState extends State<MyButtonListWidget> {
  IO.Socket socket = SocketManager().socket!;

  _MyButtonListWidgetState() {
    print("CONSTRUCTOR");
    socket.on(
        "start game",
        (data) {
          // Redirigir al widget de la batalla
          //Map<String, dynamic> objetoDeserializado = json.decode(data);
          print(data);
          var jsonMap = json.decode(data);
          Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);

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

          BattleCardGame battleCardGame =
              BattleCardGame(playerTamer, rivalTamer);

          //Convertir a BattleCardGame o delegarlo en el otro componente
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CardBattleMultiplayerView(
                      battleCardGame: battleCardGame)));
        } as EventHandler);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roomsIds.length > 0) {
      return ListView.builder(
        itemCount: widget.roomsIds.length,
        itemBuilder: (BuildContext context, int index) {
          // Para cada elemento en la lista, crea un botón con el texto correspondiente
          return ElevatedButton(
            onPressed: () {
              print("APRETO EL BOTON");
              AggregationService service = AggregationService();
              Aggregation player = service.getAggregatioByUserId(2);

              String roomId = widget.roomsIds[index];
              socket.emit('playerJoinGame', {
                "deck": player.decksAggregations[0].cards,
                "user": {
                  "id": player.user.id,
                  "username": player.user.username
                },
                "gameIdToJoin": roomId
              });
              print("EMITIO");
            },
            child: Text(widget.roomsIds[index]), // Texto del botón
          );
        },
      );
    }

    return Text('La lista está vacía');
  }
}
