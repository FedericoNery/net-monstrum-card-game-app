import 'package:net_monstrum_card_game/domain/card.dart';

class DigimonZone {
  List<Card> cards;

  DigimonZone(this.cards);

  void addToDigimonZone(Card card) {
    cards.add(card);
  }

  void removeFromDigimonZone(int index) {
    cards.removeAt(index);
  }
}