import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/state/coin_state.dart';
import 'package:net_monstrum_card_game/views/login_screen.dart';
import 'package:provider/provider.dart';

import 'infrastructure/firebase_options.dart';
import 'views/single_player_game_view.dart';

// ...

void main() async {
  await dotenv.load(fileName: "../dotenv.txt"); // Carga el archivo .env
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initHiveForFlutter();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  bool skipGoogleSession =
      dotenv.env['SKIP_GOOGLE_SESSION']?.toLowerCase() == 'true';
  if (!skipGoogleSession) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

/*   SinglePlayerGameView singlePlayerGameView = SinglePlayerGameView();
  runApp(singlePlayerGameView);
 */
  /* SocketView socketView = SocketView();
  runApp(socketView); */

  bool redirectToMultiplayer =
      dotenv.env['REDIRECT_TO_MULTIPLAYER']?.toLowerCase() == 'true';
  bool redirectToSinglePlayer =
      dotenv.env['REDIRECT_TO_SINGLE_PLAYER']?.toLowerCase() == 'true';

  bool redirectToComponentsViewer =
      dotenv.env['REDIRECT_TO_COMPONENTS_VIEWER']?.toLowerCase() == 'true';

  //final _mainNavigatorKey = GlobalKey<NavigatorState>();

  FlutterNativeSplash.remove();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => CoinState())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'PixelDigivolve',
        ),
        //navigatorKey: _mainNavigatorKey,
        home: LoginScreen(),
      )));

/*   MultiplayerGameView multiplayerGameView = MultiplayerGameView();
  runApp(multiplayerGameView); */
}
