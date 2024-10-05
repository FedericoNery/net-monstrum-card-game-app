import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/views/deck_selector_view.dart';
import 'package:net_monstrum_card_game/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool skipSplashScreen =
      dotenv.env['SKIP_SPLASH_SCREEN']?.toLowerCase() == 'true';
  bool skipGoogleSession =
      dotenv.env['SKIP_GOOGLE_SESSION']?.toLowerCase() == 'true';

  @override
  void initState() {
    super.initState();

    if (!skipSplashScreen) {
      Timer(Duration(seconds: 3), () {
        DeckSelectionScreen deckSelectionScreen = DeckSelectionScreen();

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => deckSelectionScreen));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!skipGoogleSession) {
      LoginScreen loginScreen = LoginScreen();
      return loginScreen;
    }

    if (skipSplashScreen) {
      DeckSelectionScreen deckSelectionScreen = DeckSelectionScreen();
      return deckSelectionScreen;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splash_image.png'),
      ),
    );
  }
}
