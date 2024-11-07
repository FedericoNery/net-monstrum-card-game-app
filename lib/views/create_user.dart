import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  StyledButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'monospace', // Para un estilo retro
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateUserWidget extends StatefulWidget {
  @override
  _CreateUserWidgetState createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {
  final TextEditingController _usernameController = TextEditingController();

  void _createUser(AppState appState) async {
    UsersService usersService = UsersService();

    final String username = _usernameController.text.trim();

    if (username.isEmpty) {
      // Mostrar un mensaje de error si el campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa un nombre de usuario')),
      );
    } else {
      try {
        final user = {"email": "email7@gmail.com"};
        // final user = await UserController.loginWithGoogle();
        await usersService.createUserWithEmail(user["email"]!);
        //await usersService.createUserWithEmail(user.email!);

        if (user != null && mounted) {
          final accessTokenFromApi =
              await usersService.fetchUserWithGoogleToken("", user["email"]!);
          //.fetchUserWithGoogleToken("", user.email!);
          if (accessTokenFromApi == null) {
            throw Exception("User not found in app");
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(accessTokenFromApi);

            DateTime expirationDate =
                JwtDecoder.getExpirationDate(accessTokenFromApi);

            await saveUserSession(accessTokenFromApi, expirationDate);
            appState.setUserInformation(decodedToken, accessTokenFromApi);
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

      // Limpiar el campo de entrada después de enviar
      _usernameController.clear();

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario creado exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          StyledButton(
            text: "Crear usuario",
            onPressed: () => _createUser(appState),
          ),
        ],
      ),
    );
  }
}
