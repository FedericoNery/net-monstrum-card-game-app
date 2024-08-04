import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/views/multiplayer_game_view.dart';
import 'package:net_monstrum_card_game/views/single_player_game_view.dart';
import 'package:net_monstrum_card_game/views/socket_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

/*   SinglePlayerGameView singlePlayerGameView = SinglePlayerGameView();
  runApp(singlePlayerGameView); */

  /* SocketView socketView = SocketView();
  runApp(socketView); */

  MultiplayerGameView multiplayerGameView = MultiplayerGameView();
  runApp(multiplayerGameView);
}
