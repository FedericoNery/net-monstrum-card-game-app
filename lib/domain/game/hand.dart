import 'package:net_monstrum_card_game/domain/card.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';

class Hand {
  List<Card> cards;
  List<int> selectedCards = [];

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

  void selectCardByIndex(int index){
    if (this.selectedCards.contains(index)){
      this.selectedCards.remove(index);
    }
    else{
      this.selectedCards.add(index);
    }
  }

  EnergiesCounters getEnergiesCounters(){
    EnergiesCounters energiesCounters = new EnergiesCounters.initAllInZero();
    for (Card card in this.cards) {
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
    return energiesCounters;
  }
}