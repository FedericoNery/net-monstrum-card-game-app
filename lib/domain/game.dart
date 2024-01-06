import 'package:net_monstrum_card_game/domain/game/tamer.dart';

import 'card.dart';

class Phases {
  static const String DRAW_PHASE = 'DRAW_PHASE';
  static const String SUMMON_PHASE = 'SUMMON_PHASE';
  static const String BATTLE_PHASE = 'BATTLE_PHASE';
}

class BattleCardGame {
  Tamer player;
  Tamer rival;
  String phaseGame;

  BattleCardGame(this.player, this.rival):
  phaseGame = Phases.DRAW_PHASE;

  void shuffleDeck() {
    player.deck.shuffle();
    rival.deck.shuffle();
  }

  void drawCards() {
    List<Card> playerCards = player.deck.drawCards(6);
    List<Card> rivalCards = rival.deck.drawCards(6);

    player.hand.cards = playerCards;
    rival.hand.cards = rivalCards;

    player.calculateEnergies();
    rival.calculateEnergies();
  }

  bool digimonsCanBeSummoned(){
    rival.selectAllDigimonThatCanBeSummoned();
    return player.canSummonAllDigimonSelected() && rival.canSummonAllDigimonSelected();
  }

  void calculatePoints(){
    if (digimonsCanBeSummoned()){
      player.calculatePoints();
      rival.calculatePoints();
    }
  }

  void battle(){
    player.attack(rival);
    rival.attack(player);
  }

  void calculateWinner(){
    //TODO ANALIZAR POSIBLES FORMAS DE DESEMPATAR
    // REGLAS ALEATORIAS -> mayor cantidad de energias
    // mayor cartas restantes en las manos
    // mayor cantidad de attackPoints
    if (player.healthPoints > rival.healthPoints){
      player.roundsWon += 1;
    }
    else if(rival.healthPoints > player.healthPoints){
      rival.roundsWon += 1;
    }
  }

  void finishRound(){
    //DESCARTAR TODAS LAS CARTAS QUE QUEDAN EN LA MANO A LA BASURA
    List<Card> handCardsPlayer = player.hand.cards;
    List<Card> handCardsRival = rival.hand.cards;

    player.trash.addAll(handCardsPlayer);
    rival.trash.addAll(handCardsRival);

    player.hand.clear();
    rival.hand.clear();
  }
}