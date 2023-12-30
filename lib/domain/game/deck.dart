import 'package:net_monstrum_card_game/domain/card.dart';

class Deck {
  List<Card> cards;

  Deck(this.cards);

  List<Card> drawCards(int count) {
    if (count > cards.length) {
      throw Exception("No hay suficientes cartas en el mazo");
    }

    List<Card> drawnCards = cards.sublist(0, count);
    for (Card card in drawnCards){
      print('${card.digimonName} - ${card.color}');
    }
    cards.removeRange(0, count);
    print("----");
    return drawnCards;
  }

  void shuffle(){
    this.cards.shuffle();
  }
}