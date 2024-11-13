import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //TODO COINS
    String avatarUrl =
        appState.userInformation?["avatarUrl"]!.toString() ?? "-";
    String coins = appState.userInformation?["coins"]!.toString() ?? "-";
    String username = appState.userInformation?["username"]!.toString() ?? "-";
    String email = appState.userInformation?["email"]!.toString() ?? "-";

    return Center(
        child: Container(
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
                CircleAvatar(
                  minRadius: 40,
                  maxRadius: 80,
                  backgroundImage:
                      AssetImage('assets/images/avatars/$avatarUrl'),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Text('Monedas $coins'),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
