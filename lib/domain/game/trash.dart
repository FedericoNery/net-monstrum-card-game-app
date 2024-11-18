import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';

import '../card/card_base.dart';

class Trash {
  List<Card> cards;

  Trash(this.cards);

  void add(Card card) {
    cards.add(card);
  }

  void addAll(List<Card> cards) {
    for (Card card in cards) {
      this.cards.add(card);
    }
  }

  bool isCardInTrash(int uniqueCardId) {
    return cards.any((element) => element.uniqueIdInGame! == uniqueCardId);
  }

  Card removeCardAt(int index) {
    Card card = cards[index];
    cards.removeAt(index);
    return card;
  }
}
