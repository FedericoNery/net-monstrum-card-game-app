import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms/button-widget-list.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/waiting-room.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ListRoomsPage extends StatefulWidget {
  const ListRoomsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ListRoomsPage> createState() => _ListRoomsPageState();
}

class _ListRoomsPageState extends State<ListRoomsPage> {
  int _counter = 0;
  List<String> _listRoomsIds = [];

  IO.Socket socket = SocketManager().socket!;

  void _incrementCounter() {
/*     setState(() {
      _counter++;
    }); */

    socket.emit('createNewGame', {
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      "Mi usuario"
    });
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
      print(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingRoom(
                gameId: objetoDeserializado["gameId"]!,
                socketId: objetoDeserializado["mySocketId"]!),
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
      ),
      body: Center(child: MyButtonListWidget(roomsIds: _listRoomsIds)
          /*  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
/*             const Text(
              'You have pushed the button this many times:',
            ), */
            MyButtonListWidget(roomsIds: _listRoomsIds)
          ],
          /*  <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ], */
        ), */
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
