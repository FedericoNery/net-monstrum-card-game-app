import 'package:net_monstrum_card_game/domain/card/equipment_effect.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';

import 'card/card_base.dart';
import 'card/card_digimon.dart';

class Phases {
  static const String DRAW_PHASE = 'DRAW_PHASE';
  static const String COMPILATION_PHASE = 'COMPILATION_PHASE';
  static const String SUMMON_PHASE = 'SUMMON_PHASE';
  static const String UPGRADE_PHASE = 'UPGRADE_PHASE';
  static const String BATTLE_PHASE = 'BATTLE_PHASE';
  static const String FINISHED_ROUND = 'FINISHED_PHASE';
}

class BattleCardGame {
  Tamer player;
  Tamer rival;
  String phaseGame;
  int? activatedEnergyCardId;
  int? selectedEquipmentCardId;
  int? targetDigimonId;
  List<EquipmentEffect> equipmentsEffectSelected = [];
  bool wasSummonedDigimonSpecially = false;
  bool drawedCards = false;
  bool decksShuffled = false;


  BattleCardGame(this.player, this.rival): phaseGame = Phases.DRAW_PHASE;

  BattleCardGame.fromInstance(BattleCardGame battleCardGame):
    player = battleCardGame.player,
    rival = battleCardGame.rival,
    phaseGame = battleCardGame.phaseGame,
    activatedEnergyCardId = null, //TEMPORAL FIX
    targetDigimonId = battleCardGame.targetDigimonId,
    selectedEquipmentCardId = battleCardGame.selectedEquipmentCardId,
    equipmentsEffectSelected = battleCardGame.equipmentsEffectSelected,
    wasSummonedDigimonSpecially = battleCardGame.wasSummonedDigimonSpecially,
    drawedCards = battleCardGame.drawedCards,
    decksShuffled = battleCardGame.decksShuffled;

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
    drawedCards = true;
  }

  bool digimonsCanBeSummoned(){
    return player.canSummonAllDigimonSelected() && rival.canSummonAllDigimonSelected();
  }

  void calculatePoints(){
    player.calculatePoints();
    rival.calculatePoints();
  }

  void battle(){
    phaseGame = Phases.BATTLE_PHASE;
    player.attack(rival);
    rival.attack(player);
  }

  bool battleIsFinished(){
    return player.roundsWon == 2 || rival.roundsWon == 2;
  }

  bool isPlayerWinner(){
    return player.roundsWon == 2;
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
    else{
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

    player.clearPoints();
    rival.clearPoints();

    phaseGame = Phases.FINISHED_ROUND;
  }

  void startRound(){
    phaseGame = Phases.DRAW_PHASE;
    drawCards();
  }

  void toCompilationPhase(){
    phaseGame = Phases.COMPILATION_PHASE;
  }

  void toDrawPhase(){
    phaseGame = Phases.DRAW_PHASE;
  }

  void toSummonPhase(){
    phaseGame = Phases.SUMMON_PHASE;
  }

  void toUpgradePhase(){
    phaseGame = Phases.UPGRADE_PHASE;
  }

  void toBattlePhase(){
    phaseGame = Phases.BATTLE_PHASE;
  }

  bool isCompilationPhase(){
    return phaseGame == Phases.COMPILATION_PHASE;
  }

  bool isSummonPhase(){
    return phaseGame == Phases.SUMMON_PHASE;
  }

  bool isUpgradePhase(){
    return phaseGame == Phases.UPGRADE_PHASE;
  }

  bool isBattlePhase(){
    return phaseGame == Phases.BATTLE_PHASE;
  }

  bool isDrawPhase(){
    return phaseGame == Phases.DRAW_PHASE;
  }

  bool isFinishedRound(){
    return phaseGame == Phases.FINISHED_ROUND;
  }

}