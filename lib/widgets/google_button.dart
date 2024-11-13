import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../services/firebase_auth_service.dart';

class GoogleSignInButtonState extends StatefulWidget {
  @override
  _GoogleSignInButton createState() => _GoogleSignInButton();
}

class _GoogleSignInButton extends State<GoogleSignInButtonState> {
  @override
  Widget build(BuildContext context) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();
    UsersService usersService = UsersService();
    final appState = Provider.of<AppState>(context);

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
                bool loginWithoutGoogle =
                    dotenv.env['LOGIN_WITHOUT_GOOGLE']?.toLowerCase() == 'true';
                final user = loginWithoutGoogle
                    ? {"email": "email1@gmail.com"} as Map<String, String>
                    : await UserController.loginWithGoogle() as User?;

                if (user != null && mounted) {
                  final accessTokenFromApi =
                      await usersService.fetchUserWithEmail(loginWithoutGoogle
                          ? (user as Map<String, String>)["email"]!
                          : (user as User?)!.email!);

                  bool isExpired = JwtDecoder.isExpired(accessTokenFromApi!);

                  if (isExpired) {
                    throw Exception("Expired session");
                  }

                  if (accessTokenFromApi == null) {
                    throw Exception("User not found in app");
                  } else {
                    Map<String, dynamic> decodedToken =
                        JwtDecoder.decode(accessTokenFromApi);

                    DateTime expirationDate =
                        JwtDecoder.getExpirationDate(accessTokenFromApi);

                    await saveUserSession(accessTokenFromApi, expirationDate);
                    appState.setUserInformation(
                        decodedToken, accessTokenFromApi);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                child: MenuPage(),
                              ),
                            )));
                  }
                }
              } on FirebaseAuthException catch (error) {
                print(error.message);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  error.message ?? "Something went wrong",
                )));
              } catch (error) {
                print(error);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  error.toString(),
                )));
              }
            }));
  }
}
