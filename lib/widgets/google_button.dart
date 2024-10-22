import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:net_monstrum_card_game/services/firebase_auth_service.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';
import 'package:net_monstrum_card_game/views/deck_selector_view.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';

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
              'Sign in with Google',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () async {
              try {
                // final user = await UserController.loginWithGoogle();
                final user = {"email": "email1@gmail.com"};
                if (user != null && mounted) {
                  final userFromApp = await usersService
                      .fetchUserWithGoogleToken("", user["email"]!);
                  //.fetchUserWithGoogleToken("", user.email!);

                  if (userFromApp == null) {
                    throw Exception("User not found in app");
                  } else {
                    appState.setUserInformation(userFromApp);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                //child: DeckSelectionScreen(),
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
