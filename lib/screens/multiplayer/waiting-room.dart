import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
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
