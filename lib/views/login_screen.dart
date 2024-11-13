import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
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
    final appState = Provider.of<AppState>(context);
    final TextEditingController _usernameController = TextEditingController();
    bool loginWithoutGoogle =
        dotenv.env['LOGIN_WITHOUT_GOOGLE']?.toLowerCase() == 'true';

    return FutureBuilder<UserFromLocalSession>(
      future: getUserFromLocalSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error checking login status'));
        } else if (!(snapshot.data!.isTokenExpiredOrNotExists) &&
            snapshot.data!.user != null &&
            snapshot.data!.token != "") {
          // Token is valid, navigate to home screen
          appState.setUserInformation(
              snapshot.data!.user!, snapshot.data!.token);

          return MenuPage();
        } else if (snapshot.data!.isTokenExpiredOrNotExists) {
          // Token is expired, navigate to login screen
          return Scaffold(
              appBar: AppBar(
                title: const Text('Inicio de Sesión'),
              ),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    GoogleSignInButtonState(),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledButton(
                      text: "Registrarse",
                      onPressed: () => _toCreateUserPage(context),
                    ),
                    if (loginWithoutGoogle)
                      const SizedBox(
                        height: 20,
                      ),
                    if (loginWithoutGoogle)
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de usuario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ])));
        } else {
          return Container();
        }
      },
    );
  }
}
