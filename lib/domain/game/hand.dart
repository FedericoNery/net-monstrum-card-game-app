import 'package:flame/extensions.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'package:collection/collection.dart';
import '../card/card_base.dart';

class Hand {
  List<Card> cards;
  List<int> selectedCardsInternalIds = [];

  Hand(this.cards);

  void addToHand(Card card) {
    cards.add(card);
  }

  void removeFromHand(int internalCardId) {
    int index = cards.indexWhere((card) => card.internalGameId == internalCardId);
    if(index != -1){
      cards.removeAt(index);
    }
  }

  void removeSelectedCards() {
    if (selectedCardsInternalIds.isNotEmpty){
      for (int id in selectedCardsInternalIds) {
        removeFromHand(id);
      }
    }
  }

  void clear(){
    cards.clear();
    selectedCardsInternalIds.clear();
  }

  List<CardDigimon> getSelectedCards(){
    List<CardDigimon> selectedCards = [];

    if (selectedCardsInternalIds.isNotEmpty){
      for (int id in selectedCardsInternalIds){
        Card? card = cards.firstWhereOrNull((card) => card.internalGameId == id);
        if (card != null && card.isDigimonCard()){
          selectedCards.add(card as CardDigimon);
        }
      }
    }

    return selectedCards;
  }

  void selectCardByInternalId(int internalCardId){
    if (selectedCardsInternalIds.contains(internalCardId)){
      selectedCardsInternalIds.remove(internalCardId);
    }
    else{
      selectedCardsInternalIds.add(internalCardId);
    }
  }

  void onlySelectCardByInternalId(int internalCardId){
    if (!selectedCardsInternalIds.contains(internalCardId)){
      selectedCardsInternalIds.add(internalCardId);
    }
  }

  EnergiesCounters getEnergiesCounters(){
    EnergiesCounters energiesCounters = EnergiesCounters.initAllInZero();
    Iterable<Card>  filteredDigimonCards = cards.where((card) => card.isDigimonCard() || card.isEnergyCard());
    Iterable<IColor> casted = filteredDigimonCards.cast<IColor>();
    for (IColor card in casted) {
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

  bool isDigimonCardByInternalId(int internalCardId){
    var card = cards.firstWhereOrNull((card) => card.internalGameId == internalCardId);
    return card != null && card.isDigimonCard(); //&& selectedCardsInternalIds.contains(card.internalGameId!);
  }

  bool isEquipmentCardByInternalId(int internalCardId){
    var card = cards.firstWhereOrNull((card) => card.internalGameId == internalCardId);
    return card != null && card.isEquipmentCard();
  }

  bool isEnergyCardByInternalId(int internalCardId){
    var card = cards.firstWhereOrNull((card) => card.internalGameId == internalCardId);
    return card != null && card.isEnergyCard();
  }
}