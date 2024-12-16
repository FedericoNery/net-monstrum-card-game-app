import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/infrastructure/env_service.dart';
import 'package:net_monstrum_card_game/state/coin_state.dart';
import 'package:net_monstrum_card_game/views/login_screen.dart';
import 'package:provider/provider.dart';

import 'infrastructure/firebase_options.dart';
import 'views/single_player_game_view.dart';

// ...

void main() async {
  await dotenv.load(fileName: "../dotenv.txt");
  if (!EnvService.skipGoogleSession) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  await initHiveForFlutter();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  /* SocketView socketView = SocketView();
  runApp(socketView); */

  FlutterNativeSplash.remove();

  /* SinglePlayerGameView singlePlayerGameView = SinglePlayerGameView();
  runApp(singlePlayerGameView); */

  final HttpLink httpLink = HttpLink(dotenv.env['API_URL'] ?? '');

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );

  runApp(GraphQLProvider(
      client: ValueNotifier(client),
      child: MultiProvider(
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
            home: LoginScreen(),
          ))));
}
