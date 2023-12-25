import 'package:net_monstrum_card_game/domain/card.dart';

class Trash {
  List<Card> cards;

  Trash(this.cards);

  void add(int index) {
    cards.add(cards.removeAt(index));
  }

  void remove(int index) {
    cards.removeAt(index);
  }
}