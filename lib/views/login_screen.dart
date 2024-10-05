import 'package:flutter/material.dart';

import '../widgets/google_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla de Login'),
        ),
        body: Center(
          child: GoogleSignInButtonState(),
        ));
  }
}
