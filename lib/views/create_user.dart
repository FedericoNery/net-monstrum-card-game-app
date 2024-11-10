import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/services/local_session.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart';
import '../widgets/create_user/avatar_carrousel.dart';

class StyledButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const StyledButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  _StyledButtonState createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  Color _backgroundColor = Colors.blue.shade900;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onHover: (isHovered) {
        setState(() {
          _backgroundColor =
              isHovered ? Color.fromARGB(255, 0, 42, 91) : Colors.blue.shade900;
        });
      },
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(240, 50),
        backgroundColor: _backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Colors.grey),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
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
  String _avatarUrlSelected = "assets/images/avatars/hikari.png";
  final TextEditingController _usernameController = TextEditingController();

  void _createUser(AppState appState) async {
    UsersService usersService = UsersService();

    final String username = _usernameController.text.trim();

    if (username.isEmpty) {
      // Mostrar un mensaje de error si el campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un nombre de usuario')),
      );
    } else {
      try {
        final user = {"email": "email7@gmail.com"};
        // final user = await UserController.loginWithGoogle();
        final resultMutation = await usersService.createUserWithEmail(
            user["email"]!, username, _avatarUrlSelected);

        //await usersService.createUserWithEmail(user.email!);

        if (resultMutation != null && user != null && mounted) {
          // Limpiar el campo de entrada después de enviar
          //_usernameController.clear();

          // Mostrar un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario creado exitosamente')),
          );

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
    }
  }

  void onAvatarSelected(String avatarUrl) {
    setState(() {
      _avatarUrlSelected = avatarUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear usuario'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(48, 24, 48, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarCarousel(onAvatarSelected: onAvatarSelected),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                StyledButton(
                  text: "Crear usuario",
                  onPressed: () => _createUser(appState),
                ),
              ],
            ),
          ),
        ));
  }
}
