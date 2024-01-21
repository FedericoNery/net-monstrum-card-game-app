import 'dart:ui';

import 'package:flame/components.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/factories/card_widget_factory.dart';
import '../domain/card/card_equipment.dart';
import '../domain/card/equipment_effect.dart';
import '../domain/game.dart';
import '../domain/game/tamer.dart';
import '../services/aggregation_service.dart';
import '../widgets/card_battle/color_counter.dart';
import '../widgets/card_battle/texts_counters_player.dart';
import '../widgets/card_battle/victory_message.dart';
import '../widgets/shared/background_image.dart';
import '../widgets/shared/button.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/game.dart';

class CardBattle extends FlameGame with HasGameRef {
  final background = BackgroundImage("playmat/playmat.png");

  final enabledMusic = false;
  late AudioPool pool;
  late VictoryMessage victoryMessage;

  late CardWidgetFactory playerCards;
  late CardWidgetFactory rivalCards;


  final summonDigimonButton = DefaultButton('Summon Digimon');
  final activateEquipmentButton = DefaultButton('Activate Equipment');
  final passButton = DefaultButton('Pass');

  final service = AggregationService();
  late Aggregation player;
  late Aggregation rival;

  late Tamer playerTamer;
  late Tamer rivalTamer;
  late BattleCardGame battleCardGame;
  late TextComponent apRival;
  late TextComponent hpRival;
  late TextComponent apPlayer;
  late TextComponent hpPlayer;
  final ColorCounterInstances colorCounterInstances = ColorCounterInstances();
  late TextComponent roundsWinPlayer;
  late TextComponent roundsWinRival;
  late List<TextComponent> textsCounters;
  late List<TextComponent> textsCountersRival;

  CardBattle();

  int? selectedEquipmentCardIndex;
  List<EquipmentEffect> equipmentsEffectSelected = [];

  @override
  Future<void> onLoad() async {
    pool = await FlameAudio.createPool(
      'sounds/card-battle-theme.mp3',
      minPlayers: 2,
      maxPlayers: 2,
    );
    if (enabledMusic){
      startBgmMusic();
    }

    player = service.getAggregatioByUserId(1);
    rival = service.getAggregatioByUserId(2);

    playerTamer = Tamer(player.decksAggregations[0].cards, player.user.username);
    rivalTamer = Tamer(rival.decksAggregations[0].cards, rival.user.username);

    battleCardGame = BattleCardGame(playerTamer, rivalTamer);

    //TODO ANIMACION
    battleCardGame.shuffleDeck();

    //TODO ANIMACION
    battleCardGame.drawCards();
    victoryMessage = VictoryMessage();

    playerCards = CardWidgetFactory(battleCardGame.player, false, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
    rivalCards = CardWidgetFactory(battleCardGame.rival, true, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);

    textsCounters = TextsCounters.getComponents(battleCardGame.player.energiesCounters);
    textsCountersRival = TextsCounters.getRivalComponents(battleCardGame.rival.energiesCounters);

    roundsWinPlayer = TextComponent(
      text: 'W:${battleCardGame.player.roundsWon}',
      size: Vector2.all(10.0),
      position: Vector2(0, 370),
    );

    roundsWinRival = TextComponent(
      text: 'W:${battleCardGame.rival.roundsWon}',
      size: Vector2.all(10.0),
      position: Vector2(0, 0),
    );

    apRival = TextComponent(
      text: 'AP:${battleCardGame.rival.attackPoints}',
      size: Vector2.all(10.0),
      position: Vector2(640, 0),
      scale: Vector2.all(0.8),
    );

    hpRival = TextComponent(
      text: 'HP:${battleCardGame.rival.healthPoints}',
      size: Vector2.all(10.0),
      position: Vector2(700, 0),
      scale: Vector2.all(0.8),
    );

    apPlayer = TextComponent(
      text: 'AP:${battleCardGame.player.attackPoints}',
      size: Vector2.all(10.0),
      position: Vector2(640, 370),
      scale: Vector2.all(0.8),
    );

    hpPlayer = TextComponent(
      text: 'HP:${battleCardGame.player.healthPoints}',
      size: Vector2.all(10.0),
      position: Vector2(700, 370),
      scale: Vector2.all(0.8),
    );

    summonDigimonButton.position = Vector2(650, 50);
    summonDigimonButton.size = Vector2(100, 50);
    summonDigimonButton.tapUpCallback = nextPhase;

    activateEquipmentButton.position = Vector2(650, 50);
    activateEquipmentButton.size = Vector2(100, 50);
    activateEquipmentButton.tapUpCallback = nextToBattlePhase;

    passButton.position = Vector2(650, 100);
    passButton.size = Vector2(100, 50);
    passButton.tapUpCallback = nextToBattlePhase;

    add(background);
    addCards();
    add(colorCounterInstances.blueCounter);
    add(colorCounterInstances.redCounter);
    add(colorCounterInstances.brownCounter);
    add(colorCounterInstances.whiteCounter);
    add(colorCounterInstances.blackCounter);
    add(colorCounterInstances.greenCounter);
    add(colorCounterInstances.blueCounterRival);
    add(colorCounterInstances.redCounterRival);
    add(colorCounterInstances.brownCounterRival);
    add(colorCounterInstances.whiteCounterRival);
    add(colorCounterInstances.blackCounterRival);
    add(colorCounterInstances.greenCounterRival);
    add(roundsWinPlayer);
    add(roundsWinRival);
    add(apRival);
    add(hpRival);
    add(apPlayer);
    add(hpPlayer);

    for (var textCounterComponent in textsCounters) {
      add(textCounterComponent);
    }

    for (var textCounterComponent in textsCountersRival) {
      add(textCounterComponent);
    }
    add(summonDigimonButton);

    battleCardGame.toSummonPhase();
    //this.revealPlayerCards();
  }


  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('sounds/card-battle-theme.mp3');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  void updateApHp(){
    apRival.text = 'AP:${battleCardGame.rival.attackPoints}';
    hpRival.text = 'HP:${battleCardGame.rival.healthPoints}';
    apPlayer.text = 'AP:${battleCardGame.player.attackPoints}';
    hpPlayer.text = 'HP:${battleCardGame.player.healthPoints}';
    apRival.update(1);
    hpRival.update(1);
    apPlayer.update(1);
    hpPlayer.update(1);
  }

  void updateRounds(){
    roundsWinPlayer.text = 'W:${battleCardGame.player.roundsWon}';
    roundsWinRival.text = 'W:${battleCardGame.rival.roundsWon}';
    roundsWinPlayer.update(1);
    roundsWinRival.update(1);
  }

  void nextToBattlePhase(){
    battlePhase();
  }

  void nextPhase() {
    //TODO :: borrar esto más adelante al seguir desarrollando
    battleCardGame.rival.selectAllDigimonThatCanBeSummoned();

    if (battleCardGame.digimonsCanBeSummoned()) {
      remove(summonDigimonButton);

      battleCardGame.player.summonToDigimonZone();
      battleCardGame.rival.summonToDigimonZone();

      TextsCounters.updateComponents(textsCounters, battleCardGame.player.energiesCounters);
      TextsCounters.updateComponents(textsCountersRival, battleCardGame.rival.energiesCounters);

      battleCardGame.calculatePoints();

      removeNotSummonedCardsByPlayer();
      playerCards.deselectCards();
      battleCardGame.player.removeSelectedCardsSummoned();

      removeNotSummonedCardsByRival();
      rivalCards.revealSelectedCards();
      battleCardGame.rival.removeSelectedCardsSummoned();

      updateApHp();
      //TODO Sleep de 2 segundos
      battleCardGame.toUpgradePhase();
      add(activateEquipmentButton);
    }
  }


  void activateEquipment(int internalCardId, CardEquipment equipmentEffect){
    selectedEquipmentCardIndex = internalCardId;
    equipmentsEffectSelected = equipmentEffect.getEffects(battleCardGame.player.digimonZone);
  }

  void confirmApplyEffect(){
    //TODO ver addSelectedCard(selectedEquipmentCardIndex!);
    nextPhase();
  }

  void targetOfEquipment(int index){
    int internalCardIdActivated = selectedEquipmentCardIndex!;
    battleCardGame.player.hand.removeFromHand(selectedEquipmentCardIndex!);
    battleCardGame.player.digimonZone.applyEffectTo(index, equipmentsEffectSelected.removeLast());
    battleCardGame.player.calculatePoints();
    updateApHp();

    removeCardAfterEquipmentActivation(internalCardIdActivated);
  }

  void removeCardAfterEquipmentActivation(int internalCardIdActivated){
    if (playerCards.card1.isMounted && playerCards.card1.internalCardId == internalCardIdActivated){
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted && playerCards.card2.internalCardId == internalCardIdActivated){
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted && playerCards.card3.internalCardId == internalCardIdActivated){
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted && playerCards.card4.internalCardId == internalCardIdActivated){
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted && playerCards.card5.internalCardId == internalCardIdActivated){
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted && playerCards.card6.internalCardId == internalCardIdActivated){
      remove(playerCards.card6);
    }
  }

  void battlePhase() async {
    battleCardGame.battle();
    //TODO SLEEP de 2 segundos
    await Future.delayed(Duration(seconds: 5));
    updateApHp();

    battleCardGame.calculateWinner();
    updateRounds();
    battleCardGame.finishRound();

    await Future.delayed(Duration(seconds: 5));

    if (battleCardGame.battleIsFinished()){
      //TODO Remover todos los elementos visuales
      removeAllCards();
      if(battleCardGame.isPlayerWinner()){
        victoryMessage.text = "Ganaste";
      }
      else{
        victoryMessage.text = "Perdiste";
      }
      add(victoryMessage);
    }
    else{
      updateApHp();
      battleCardGame.toDrawPhase();
      battleCardGame.drawCards();
      //TODO llamar método para agregar devuelta los widgets de cartas
      removeAllCards();
      setCardsWidgets();
      addCards();
      TextsCounters.updateComponents(textsCounters, battleCardGame.player.energiesCounters);
      TextsCounters.updateComponents(textsCountersRival, battleCardGame.rival.energiesCounters);
      add(summonDigimonButton);
      battleCardGame.toSummonPhase();
    }
  }


  bool isEnabledToEquip(){
    return battleCardGame.isUpgradePhase();
  }

  void setCardsWidgets(){
    playerCards = CardWidgetFactory(battleCardGame.player, false, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
    rivalCards = CardWidgetFactory(battleCardGame.rival, true, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
  }



  void addCards() async{
    add(playerCards.card1);
    add(playerCards.card2);
    add(playerCards.card3);
    add(playerCards.card4);
    add(playerCards.card5);
    add(playerCards.card6);
    add(rivalCards.card1);
    add(rivalCards.card2);
    add(rivalCards.card3);
    add(rivalCards.card4);
    add(rivalCards.card5);
    add(rivalCards.card6);
  }

  void updateCards(){
    playerCards.updateCards();
    rivalCards.updateCards();
  }

  void removeAllCards(){
    if (playerCards.card1.isMounted){
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted){
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted){
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted){
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted){
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted){
      remove(playerCards.card6);
    }
    if (rivalCards.card1.isMounted){
      remove(rivalCards.card1);
    }
    if (rivalCards.card2.isMounted){
      remove(rivalCards.card2);
    }
    if (rivalCards.card3.isMounted){
      remove(rivalCards.card3);
    }
    if (rivalCards.card4.isMounted){
      remove(rivalCards.card4);
    }
    if (rivalCards.card5.isMounted){
      remove(rivalCards.card5);
    }
    if (rivalCards.card6.isMounted){
      remove(rivalCards.card6);
    }
  }

  void removeNotSummonedCardsByPlayer(){
    if (isEnabledToSummonDigimonCard(playerCards.card1.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card1.internalCardId!)){
      playerCards.card1.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(playerCards.card2.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card2.internalCardId!)){
      playerCards.card2.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(playerCards.card3.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card3.internalCardId!)){
      playerCards.card3.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(playerCards.card4.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card4.internalCardId!)){
      playerCards.card4.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(playerCards.card5.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card5.internalCardId!)){
      playerCards.card5.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(playerCards.card6.internalCardId!) && !battleCardGame.player.wasSelectedCard(playerCards.card6.internalCardId!)){
      playerCards.card6.removeFromParent();
    }

  }

  void removeNotSummonedCardsByRival(){
    if (isEnabledToSummonDigimonCardRival(rivalCards.card1.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card1.internalCardId!)){
      rivalCards.card1.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(rivalCards.card2.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card2.internalCardId!)){
      rivalCards.card2.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(rivalCards.card3.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card3.internalCardId!)){
      rivalCards.card3.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(rivalCards.card4.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card4.internalCardId!)){
      rivalCards.card4.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(rivalCards.card5.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card5.internalCardId!)){
      rivalCards.card5.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(rivalCards.card6.internalCardId!) && !battleCardGame.rival.wasSelectedCard(rivalCards.card6.internalCardId!)){
      rivalCards.card6.removeFromParent();
    }
  }

  void addSelectedCard(int internalCardId) {
    if (battleCardGame.isSummonPhase() && battleCardGame.player.hand.isDigimonCardSelected(internalCardId)){
      battleCardGame.player.hand.selectCardByInternalId(internalCardId);
    }

    if (battleCardGame.isUpgradePhase() && battleCardGame.player.hand.isEquipmentCardSelected(internalCardId)){
      battleCardGame.player.hand.selectCardByInternalId(internalCardId);
    }
  }

  bool isEnabledToSummonDigimonCard(int internalCardId){
    return battleCardGame.isSummonPhase() && battleCardGame.player.hand.isDigimonCardSelected(internalCardId);
  }

  bool isEnabledToActivaEquipmentCard(int internalCardId){
    return battleCardGame.isUpgradePhase() && battleCardGame.player.hand.isEquipmentCardSelected(internalCardId);
  }

  bool isEnabledToSummonDigimonCardRival(int internalCardId){
    return battleCardGame.isSummonPhase() && battleCardGame.rival.hand.isDigimonCardSelected(internalCardId);
  }

  bool isEnabledToActivaEquipmentCardRival(int internalCardId){
    return battleCardGame.isUpgradePhase() && battleCardGame.rival.hand.isEquipmentCardSelected(internalCardId);
  }

}
