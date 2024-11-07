import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/list-rooms.dart';

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
        home: null //const ListRoomsPage(title: 'List Rooms Page'),
        );
  }
}
