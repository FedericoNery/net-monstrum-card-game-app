import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //TODO COINS
    //String coins = appState.userInformation?["coins"]!.toString() ?? "-";
    String username = appState.userInformation?["username"]!.toString() ?? "-";
    String email = appState.userInformation?["email"]!.toString() ?? "-";

    return Container(
      height: 400,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  minRadius: 40,
                  maxRadius: 80,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/50'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(email,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 10),
                Text('Coins -'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
