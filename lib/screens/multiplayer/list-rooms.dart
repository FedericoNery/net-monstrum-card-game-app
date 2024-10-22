import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/adapters/list_card_adapter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/main.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms/button-widget-list.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/waiting-room.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ListRoomsPage extends StatefulWidget {
  const ListRoomsPage({super.key, required this.title});

  final String title;

  @override
  State<ListRoomsPage> createState() => _ListRoomsPageState();
}

class _ListRoomsPageState extends State<ListRoomsPage> {
  List<String> _listRoomsIds = [];

  IO.Socket socket = SocketManager().socket!;

  void _createRoom(Map<String, dynamic> roomParameters) {
    bool loadLocalDeckPlayer1 =
        dotenv.env['LOAD_LOCAL_DECK_PLAYER1']?.toLowerCase() == 'true';

    socket.emit(
        'createNewGame',
        loadLocalDeckPlayer1
            ? {
                "deck": roomParameters["castedDeckToMultiplayer"],
                "user": {
                  "id": roomParameters["userId"],
                  "username": roomParameters["username"]
                }
              }
            : {
                "deck": ListCardAdapter.getListOfCardsInstantiated(
                    roomParameters["selectedDeckToMultiplayer"]),
                "user": {
                  "id": roomParameters["userId"],
                  "username": roomParameters["username"]
                }
              });
  }

  void _refreshRooms() {
    socket.emit('obtener rooms', null);
  }

  @override
  void initState() {
    super.initState();
    socket.on("send rooms", (data) {
      Map<String, dynamic> objetoDeserializado = json.decode(data);
      setState(() {
        _listRoomsIds =
            List<String>.from(objetoDeserializado["roomsConUnSoloJugador"]);
      });
    });

    socket.on('new game created', (data) {
      Map<String, dynamic> objetoDeserializado = json.decode(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => const CardBattleMultiplayerView(),
            builder: (context) => WaitingRoom(
              gameId: objetoDeserializado['gameId'],
              socketId: objetoDeserializado["mySocketId"],
            ),
          ));
    });

    socket.emit('obtener rooms', null);

    //socket.emit('obtener rooms');
  }

  @override
  void dispose() {
    //socket.disconnect();
    //socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    var roomParameters = {
      "castedDeckToMultiplayer": appState.castedDeckToMultiplayer,
      "userId": appState.userId,
      "username": appState.username,
      "selectedDeckToMultiplayer": appState.selectedDeckToMultiplayer!
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Rooms',
            onPressed: _refreshRooms,
          ),
        ],
      ),
      body: Center(child: MyButtonListWidget(roomsIds: _listRoomsIds)),
      floatingActionButton: FloatingActionButton(
        heroTag: "fabCreateRoom",
        onPressed: () => _createRoom(roomParameters),
        tooltip: 'Create Room',
        child: const Icon(Icons.add),
      ),
    );
  }
}
