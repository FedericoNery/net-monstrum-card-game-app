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
  int rondasGanadas;

  Tamer(List<Card> deckCards, username) :
  this.deck = new Deck(deckCards),
  this.username = username,
  this.trash = new Trash([]),
  this.hand = new Hand([]),
  this.digimonZone = new DigimonZone([]),
  this.energiesCounters = EnergiesCounters.initAllInZero(),
  this.attackPoints = 0,
  this.healthPoints = 0,
  this.rondasGanadas = 0;
}