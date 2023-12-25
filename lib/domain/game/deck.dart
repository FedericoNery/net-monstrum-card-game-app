import 'package:net_monstrum_card_game/domain/card.dart';

class Deck {
  List<Card> cards;

  Deck(this.cards);

  List<Card> drawCards(int count) {
    if (count > cards.length) {
      throw Exception("No hay suficientes cartas en el mazo");
    }

    List<Card> drawnCards = cards.sublist(0, count);
    cards.removeRange(0, count);
    return drawnCards;
  }
}