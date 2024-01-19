import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game/deck.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'package:net_monstrum_card_game/domain/game/hand.dart';
import 'package:net_monstrum_card_game/domain/game/trash.dart';

import '../card/card_base.dart';

class Tamer {
  Deck deck;
  Trash trash;
  Hand hand;
  DigimonZone digimonZone;
  EnergiesCounters energiesCounters;
  String username;
  int attackPoints;
  int healthPoints;
  int roundsWon;

  Tamer(List<Card> deckCards, username)
      :
        deck = Deck(deckCards),
        username = username,
        trash = Trash([]),
        hand = Hand([]),
        digimonZone = DigimonZone([]),
        energiesCounters = EnergiesCounters.initAllInZero(),
        attackPoints = 0,
        healthPoints = 0,
        roundsWon = 0;

  void attack(Tamer rival) {
    rival.receiveAttack(attackPoints);
    //TODO ANIMACION DE REDUCCION DE ATTACK POINTS
    attackPoints = 0;
  }

  void receiveAttack(int points) {
    healthPoints = points >= healthPoints ? 0 : healthPoints - points;
  }

  void calculateEnergies() {
    energiesCounters.accumulate(hand.getEnergiesCounters());
  }

  void calculatePoints() {
    attackPoints = digimonZone.getAttackPoints();
    healthPoints = digimonZone.getHealthPoints();
  }

  void selectAllDigimonThatCanBeSummoned() {
    EnergiesCounters energiesCounters = this.energiesCounters.getCopy();

    for (Card card in hand.cards) {
      if (card.isDigimonCard()){
        var cardDigimon = card as CardDigimon;
        if (energiesCounters.canBeDiscountedByColor(cardDigimon.color)) {
          energiesCounters.discountByColor(card.color);
          hand.onlySelectCardByInternalId(card.internalGameId!);
        }
      }
    }
  }

  //TODO Tomar el color de energia y la CANTIDAD de energias que consume la carta
  bool canSummonAllDigimonSelected(){
    List<CardDigimon> digimonsToSummon = hand.getSelectedCards();
    EnergiesCounters energiesCountersCopy = energiesCounters.getCopy();
    if (digimonsToSummon.isNotEmpty){
      for (CardDigimon card in digimonsToSummon){
        energiesCountersCopy.discountByColor(card.color);
      }
    }
    return energiesCountersCopy.allEnergiesAreZeroOrMore();
  }

  void summonToDigimonZone(){
    List<CardDigimon> cardsToSummon = this.hand.getSelectedCards();
    discountEnergiesToSummon(cardsToSummon);
    digimonZone.cards = cardsToSummon;
  }

  void removeSelectedCardsSummoned(){
    hand.removeSelectedCards();
    hand.selectedCardsInternalIds.clear();
  }

  void discountEnergiesToSummon(List<CardDigimon> cardsToSummon){
    if (cardsToSummon.isNotEmpty){
      for (CardDigimon card in cardsToSummon){
        energiesCounters.discountByColor(card.color);
      }
    }
  }

  void clearPoints(){
    attackPoints = 0;
    healthPoints = 0;
  }

  bool wasSelectedCard(int internalCardId){
    return hand.selectedCardsInternalIds.contains(internalCardId);
  }

}