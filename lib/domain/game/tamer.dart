import 'package:net_monstrum_card_game/domain/card.dart';
import 'package:net_monstrum_card_game/domain/game/deck.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'package:net_monstrum_card_game/domain/game/hand.dart';
import 'package:net_monstrum_card_game/domain/game/trash.dart';

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

  Tamer(List<Card> deckCards, username) :
  this.deck = new Deck(deckCards),
  this.username = username,
  this.trash = new Trash([]),
  this.hand = new Hand([]),
  this.digimonZone = new DigimonZone([]),
  this.energiesCounters = EnergiesCounters.initAllInZero(),
  this.attackPoints = 0,
  this.healthPoints = 0,
  this.roundsWon = 0;

  void attack(Tamer rival){
    rival.receiveAttack(this.attackPoints);
    //TODO ANIMACION DE REDUCCION DE ATTACK POINTS
    this.attackPoints = 0;
  }

  void receiveAttack(int points){
    this.healthPoints = points >= healthPoints ? 0 : healthPoints - points;
  }

  void calculateEnergies(){
    this.energiesCounters.accumulate(this.hand.getEnergiesCounters());
  }

  void calculatePoints(){
    this.attackPoints = this.digimonZone.getAttackPoints();
    this.healthPoints = this.digimonZone.getHealthPoints();
  }

  void selectAllDigimonThatCanBeSummoned(){
    List<Card> digimonsToSummon = this.hand.cards;
    EnergiesCounters energiesCounters = this.energiesCounters.getCopy();
    int counter = 0;

    for (Card card in digimonsToSummon){
      if(energiesCounters.canBeDiscountedByColor(card.color)){
        energiesCounters.discountByColor(card.color);
        this.hand.onlySelectCardByIndex(counter);
      }
      counter++;
    }
  }
  //TODO Tomar el color de energia y la CANTIDAD de energias que consume la carta
  bool canSummonAllDigimonSelected(){
    List<Card> digimonsToSummon = this.hand.getSelectedCards();
    EnergiesCounters energiesCountersCopy = this.energiesCounters.getCopy();
    if (digimonsToSummon.isNotEmpty){
      for (Card card in digimonsToSummon){
        energiesCountersCopy.discountByColor(card.color);
      }
    }
    return energiesCountersCopy.allEnergiesAreZeroOrMore();
  }

  void summonToDigimonZone(){
    List<Card> cardsToSummon = this.hand.getSelectedCards();
    this.discountEnergiesToSummon(cardsToSummon);
    this.digimonZone.cards = cardsToSummon;
    this.hand.removeSelectedCards();
  }

  void discountEnergiesToSummon(List<Card> cardsToSummon){
    if (cardsToSummon.length > 0){
      for (Card card in cardsToSummon){
        this.energiesCounters.discountByColor(card.color);
      }
    }
  }

  void clearPoints(){
    this.attackPoints = 0;
    this.healthPoints = 0;
  }

}