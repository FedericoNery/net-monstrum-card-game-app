import 'package:flame/extensions.dart';
import 'package:net_monstrum_card_game/domain/card.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';

class Hand {
  List<Card> cards;
  List<int> selectedCardsIndexs = [];

  Hand(this.cards);

  void addToHand(Card card) {
    cards.add(card);
  }

  void removeFromHand(int index) {
    cards.removeAt(index);
  }

  void removeSelectedCards() {
    if (selectedCardsIndexs.isNotEmpty){
      selectedCardsIndexs.sort();
      for (int i = selectedCardsIndexs.length - 1; i >= 0; i--) {
        cards.removeAt(selectedCardsIndexs[i]);
      }
    }
  }

  void clear(){
    cards.clear();
    selectedCardsIndexs.clear();
  }

  List<Card> getSelectedCards(){
    List<Card> selectedCards = [];
    this.selectedCardsIndexs.sort();
    print(this.selectedCardsIndexs);
    this.selectedCardsIndexs.reverse();
    if (this.selectedCardsIndexs.isNotEmpty){
      for (int index in this.selectedCardsIndexs){
        print(index);
        selectedCards.add(this.cards[index]);
      }
    }

    return selectedCards;
  }

  void selectCardByIndex(int index){
    if (this.selectedCardsIndexs.contains(index)){
      this.selectedCardsIndexs.remove(index);
    }
    else{
      this.selectedCardsIndexs.add(index);
    }
  }

  void onlySelectCardByIndex(int index){
    if (!this.selectedCardsIndexs.contains(index)){
      this.selectedCardsIndexs.add(index);
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