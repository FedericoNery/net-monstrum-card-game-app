import 'package:net_monstrum_card_game/domain/card.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';

class Hand {
  List<Card> cards;

  Hand(this.cards);

  void addToHand(Card card) {
    cards.add(card);
  }

  void removeFromHand(int index) {
    cards.removeAt(index);
  }

  void clear(){
    cards.clear();
  }

  EnergiesCounters getEnergiesCounters(){
    EnergiesCounters energiesCounters = new EnergiesCounters.initAllInZero();
    for (Card card in this.cards) {
      print(card.color);
      if (card.isRedColor()){
        energiesCounters.red += 1;
      }
      if (card.isBlackColor()){
        energiesCounters.black += 1;
      }
      if (card.isBlueColor()){
        energiesCounters.blue += 1;
      }
      if (card.isBrownColor()){
        energiesCounters.brown += 1;
      }
      if (card.isWhiteColor()){
        energiesCounters.white += 1;
      }
      if (card.isGreenColor()){
        energiesCounters.green += 1;
      }
    }
    print("--------");
    return energiesCounters;
  }
}