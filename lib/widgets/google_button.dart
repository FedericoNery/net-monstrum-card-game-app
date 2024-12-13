import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/infrastructure/env_service.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';
import 'package:net_monstrum_card_game/state/coin_state.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../services/firebase_auth_service.dart';

class GoogleSignInButtonState extends StatefulWidget {
  TextEditingController usernameController;

  GoogleSignInButtonState(this.usernameController);

  @override
  _GoogleSignInButton createState() => _GoogleSignInButton();
}

class _GoogleSignInButton extends State<GoogleSignInButtonState> {
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  void showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade600,
        content: Text(
          message ?? "Ocurrió un error",
        )));
  }

  @override
  Widget build(BuildContext context) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();
    UsersService usersService = UsersService();
    final appState = Provider.of<AppState>(context);
    final coinState = Provider.of<CoinState>(context);

    return GraphQLProvider(
        client: graphQlClientManager.client,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(240, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey),
            ),
            icon: Image.asset(
              'images/google-logo.png',
              height: 24,
              width: 24,
            ),
            label: const Text(
              'Iniciar sesión con Google',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () async {
              try {
                final usernameText = widget.usernameController.text.trim();
                if (!isValidEmail(usernameText)) {
                  showError(context, "El email es inválido");
                  return;
                }

                final user = EnvService.loginWithoutGoogle
                    ? {"email": widget.usernameController.text.trim()}
                    : await UserController.loginWithGoogle();

                if (user != null && mounted) {
                  final accessTokenFromApi = await usersService
                      .fetchUserWithEmail(EnvService.loginWithoutGoogle
                          ? (user as Map<String, String>)["email"]!
                          : (user as User?)!.email!);

                  if (accessTokenFromApi == null) {
                    showError(context, "Usuario no encontrado");
                    return;
                  }

                  Map<String, dynamic> decodedToken =
                      JwtDecoder.decode(accessTokenFromApi);

                  DateTime expirationDate =
                      JwtDecoder.getExpirationDate(accessTokenFromApi);

                  await saveUserSession(accessTokenFromApi, expirationDate);
                  appState.setUserInformation(decodedToken, accessTokenFromApi);

                  coinState.setCoins(decodedToken["coins"]);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(
                              child: MenuPage(),
                            ),
                          )));
                }
              } on FirebaseAuthException catch (error) {
                showError(context, error.message);
              } catch (error) {
                print(error);
                showError(context, error.toString());
              }
            }));
  }
}
