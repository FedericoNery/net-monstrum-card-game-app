import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms/button-widget-list.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/waiting-room.dart';
import 'package:net_monstrum_card_game/services/aggregation_service.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
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

  void _createRoom() {
    AggregationService service = AggregationService();
    Aggregation player = service.getAggregatioByUserId(1);

    socket.emit('createNewGame', {
      "deck": player.decksAggregations[0].cards,
      "user": {"id": player.user.id, "username": player.user.username}
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
        onPressed: _createRoom,
        tooltip: 'Create Room',
        child: const Icon(Icons.add),
      ),
    );
  }
}
