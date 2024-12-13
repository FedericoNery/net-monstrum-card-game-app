import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/infrastructure/env_service.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';
import 'package:net_monstrum_card_game/state/coin_state.dart';
import 'package:net_monstrum_card_game/views/create_user.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';

import '../widgets/google_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _toCreateUserPage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                //child: DeckSelectionScreen(),
                child: CreateUserWidget(),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    return FutureBuilder<UserFromLocalSession>(
      future: getUserFromLocalSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al revisar estado de sesión'));
        }

        if (snapshot.data!.hasInformationInLocalStorage()) {
          // Token is valid, navigate to home screen
          final appState = Provider.of<AppState>(context, listen: false);
          final coinState = Provider.of<CoinState>(context, listen: false);

          //Hacer consulta sobre cuantas monedas tiene el usuario y setear state
          coinState.setWithoutListener(snapshot.data!.user!["coins"]);
          appState.setUserInformation(
              snapshot.data!.user!, snapshot.data!.token);
          print("ENTRó");
          return MenuPage();
        }

        if (snapshot.data!.isTokenExpiredOrNotExists) {
          // Token is expired, navigate to login screen
          return Scaffold(
              appBar: AppBar(
                title: const Text('Inicio de Sesión'),
              ),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    GoogleSignInButtonState(usernameController),
                    if (EnvService.loginWithoutGoogle)
                      Padding(
                          padding: const EdgeInsets.fromLTRB(48, 20, 48, 40),
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Ingrese el email registrado',
                              border: OutlineInputBorder(),
                            ),
                          )),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledButton(
                      text: "Registrarse",
                      onPressed: () => _toCreateUserPage(context),
                    ),
                  ])));
        }

        return Container();
      },
    );
  }
}
