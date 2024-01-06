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
    EnergiesCounters energiesCounters = this.energiesCounters.getCopy();
    for (Card card in digimonsToSummon){
      energiesCounters.discountByColor(card.color);
    }
    return this.energiesCounters.allEnergiesAreZeroOrMore();
  }

  
}