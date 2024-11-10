import 'dart:ui';

import 'package:net_monstrum_card_game/widgets/shared/icon_with_counter.dart';
import '../../domain/game.dart';
import '../../screens/singleplayer/rounded_rectangle_component.dart';

class CountersCardsSectionPlayer {
  late IconWithCounter deckPlayer;
  late IconWithCounter discardPlayer;
  late IconWithCounter handPlayer;
  late RectanguloRedondeadoComponent secondaryLayer;
  late RectanguloRedondeadoComponent firstLayer;

  CountersCardsSectionPlayer() {
    deckPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 240,
        imageUrl: "assets/images/playmat/deck_icon.png");
    discardPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 280,
        imageUrl: "assets/images/playmat/trash_icon.png");
    handPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 320,
        imageUrl: "assets/images/playmat/hand_icon.png");

    secondaryLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(24, 49, 123, 1),
        top: 225,
        left: 650,
        width: 100,
        height: 140,
        borderRadius: 0);

    firstLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(74, 90, 132, 1),
        top: 230,
        left: 660,
        width: 90,
        height: 130,
        borderRadius: 4);
  }

  updateValues(BattleCardGame battleCardGame) {
    deckPlayer.cantidad = battleCardGame.player.deck.cards.length;
    discardPlayer.cantidad = battleCardGame.player.trash.cards.length;
    handPlayer.cantidad = battleCardGame.player.hand.cards.length;
  }
}

class CountersCardsSectionRival {
  late IconWithCounter deckRival;
  late IconWithCounter discardRival;
  late IconWithCounter handRival;
  late RectanguloRedondeadoComponent secondaryLayer;
  late RectanguloRedondeadoComponent firstLayer;

  CountersCardsSectionRival() {
    deckRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 50,
        imageUrl: "assets/images/playmat/deck_icon.png");
    discardRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 90,
        imageUrl: "assets/images/playmat/trash_icon.png");
    handRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 130,
        imageUrl: "assets/images/playmat/hand_icon.png");

    secondaryLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(123, 24, 42, 1),
        top: 35,
        left: 650,
        width: 100,
        height: 140,
        borderRadius: 0);

    firstLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(132, 74, 82, 1),
        top: 40,
        left: 660,
        width: 90,
        height: 130,
        borderRadius: 4);
  }

  updateValues(BattleCardGame battleCardGame) {
    deckRival.cantidad = battleCardGame.rival.deck.cards.length;
    discardRival.cantidad = battleCardGame.rival.trash.cards.length;
    handRival.cantidad = battleCardGame.rival.hand.cards.length;
  }
}
