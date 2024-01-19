import 'dart:ui';

import 'package:flame/components.dart';
import '../domain/card/card_digimon.dart';
import '../domain/card/card_equipment.dart';
import '../domain/card/equipment_effect.dart';
import '../domain/game.dart';
import '../domain/game/tamer.dart';
import '../services/aggregation_service.dart';
import '../widgets/card_battle/card_widget_base.dart';
import '../widgets/card_battle/color_counter.dart';
import '../widgets/card_battle/digimon_card.dart';
import '../widgets/card_battle/equipment_card.dart';
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
  late CardWidget card1;
  late CardWidget card2;
  late CardWidget card3;
  late CardWidget card4;
  late CardWidget card5;
  late CardWidget card6;
  late CardWidget card1Rival;
  late CardWidget card2Rival;
  late CardWidget card3Rival;
  late CardWidget card4Rival;
  late CardWidget card5Rival;
  late CardWidget card6Rival;


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

    setCardsWidgets();

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

  void revealRivalCards() {
    if (!card1Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card1Rival.internalCardId!)){
      card1Rival.reveal();
    }
    if (!card2Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card2Rival.internalCardId!)){
      card2Rival.reveal();
    }
    if (!card3Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card3Rival.internalCardId!)){
      card3Rival.reveal();
    }
    if (!card4Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card4Rival.internalCardId!)){
      card4Rival.reveal();
    }
    if (!card5Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card5Rival.internalCardId!)){
      card5Rival.reveal();
    }
    if (!card6Rival.isRemoved && battleCardGame.rival.wasSelectedCard(card6Rival.internalCardId!)){
      card6Rival.reveal();
    }
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
      deselectPlayerCards();
      battleCardGame.player.removeSelectedCardsSummoned();

      removeNotSummonedCardsByRival();
      revealRivalCards();
      battleCardGame.rival.removeSelectedCardsSummoned();

      updateApHp();
      //TODO Sleep de 2 segundos
      battleCardGame.toUpgradePhase();
      add(activateEquipmentButton);
    }
  }

  void deselectPlayerCards(){
    card1.deselectCardEffect();
    card2.deselectCardEffect();
    card3.deselectCardEffect();
    card4.deselectCardEffect();
    card5.deselectCardEffect();
    card6.deselectCardEffect();
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
    if (card1.isMounted && card1.internalCardId == internalCardIdActivated){
      remove(card1);
    }
    if (card2.isMounted && card2.internalCardId == internalCardIdActivated){
      remove(card2);
    }
    if (card3.isMounted && card3.internalCardId == internalCardIdActivated){
      remove(card3);
    }
    if (card4.isMounted && card4.internalCardId == internalCardIdActivated){
      remove(card4);
    }
    if (card5.isMounted && card5.internalCardId == internalCardIdActivated){
      remove(card5);
    }
    if (card6.isMounted && card6.internalCardId == internalCardIdActivated){
      remove(card6);
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
    const offsetX = 100.0;
    const offsetYPlayer = 250.0;
    const card1x = offsetX + 10;
    const card1y = offsetYPlayer;
    const card2x = offsetX + 100;
    const card2y = offsetYPlayer;
    const card3x = offsetX + 190;
    const card3y = offsetYPlayer;
    const card4x = offsetX + 280;
    const card4y = offsetYPlayer;
    const card5x = offsetX + 370;
    const card5y = offsetYPlayer;
    const card6x = offsetX + 450;
    const card6y = offsetYPlayer;

    card1 = battleCardGame.player.hand.cards[0].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[0] as CardDigimon, card1x, card1y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[0].internalGameId! )
        : CardEquipmentWidget(battleCardGame.player.hand.cards[0] as CardEquipment, card1x, card1y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[0].internalGameId!);

    card2 = battleCardGame.player.hand.cards[1].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[1] as CardDigimon, card2x, card2y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[1].internalGameId!)
        : CardEquipmentWidget(battleCardGame.player.hand.cards[1] as CardEquipment, card2x, card2y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[1].internalGameId!);

    card3 = battleCardGame.player.hand.cards[2].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[2] as CardDigimon, card3x, card3y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[2].internalGameId!)
        : CardEquipmentWidget(battleCardGame.player.hand.cards[2] as CardEquipment, card3x, card3y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[2].internalGameId!);

    card4 = battleCardGame.player.hand.cards[3].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[3] as CardDigimon, card4x, card4y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[3].internalGameId!)
        : CardEquipmentWidget(battleCardGame.player.hand.cards[3] as CardEquipment, card4x, card4y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[3].internalGameId!);

    card5 = battleCardGame.player.hand.cards[4].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[4] as CardDigimon, card5x, card5y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[4].internalGameId!)
        : CardEquipmentWidget(battleCardGame.player.hand.cards[4] as CardEquipment, card5x, card5y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[4].internalGameId!);

    card6 = battleCardGame.player.hand.cards[5].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.player.hand.cards[5] as CardDigimon, card6x, card6y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,battleCardGame.player.hand.cards[5].internalGameId!)
        : CardEquipmentWidget(battleCardGame.player.hand.cards[5] as CardEquipment, card6x, card6y, false, addSelectedCard, false, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.player.hand.cards[5].internalGameId!);

    const offsetYCards = 25.0;
    const card1Rivalx = offsetX + 10;
    const card1Rivaly = offsetYCards;
    const card2Rivalx = offsetX + 100;
    const card2Rivaly = offsetYCards;
    const card3Rivalx = offsetX + 190;
    const card3Rivaly = offsetYCards;
    const card4Rivalx = offsetX + 280;
    const card4Rivaly = offsetYCards;
    const card5Rivalx = offsetX + 370;
    const card5Rivaly = offsetYCards;
    const card6Rivalx = offsetX + 450;
    const card6Rivaly = offsetYCards;

    card1Rival = battleCardGame.rival.hand.cards[0].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[0] as CardDigimon, card1Rivalx, card1Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, battleCardGame.rival.hand.cards[0].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[0] as CardEquipment, card1Rivalx, card1Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[0].internalGameId!);
    card2Rival = battleCardGame.rival.hand.cards[1].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[1] as CardDigimon, card2Rivalx, card2Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,  battleCardGame.rival.hand.cards[1].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[1] as CardEquipment, card2Rivalx, card2Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[1].internalGameId!);
    card3Rival = battleCardGame.rival.hand.cards[2].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[2] as CardDigimon, card3Rivalx, card3Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, battleCardGame.rival.hand.cards[2].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[2] as CardEquipment, card3Rivalx, card3Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[2].internalGameId!);
    card4Rival = battleCardGame.rival.hand.cards[3].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[3] as CardDigimon, card4Rivalx, card4Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, battleCardGame.rival.hand.cards[3].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[3] as CardEquipment, card4Rivalx, card4Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[3].internalGameId!);
    card5Rival = battleCardGame.rival.hand.cards[4].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[4] as CardDigimon, card5Rivalx, card5Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, battleCardGame.rival.hand.cards[4].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[4] as CardEquipment, card5Rivalx, card5Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[4].internalGameId!);
    card6Rival = battleCardGame.rival.hand.cards[5].isDigimonCard() ?
    CardDigimonWidget(battleCardGame.rival.hand.cards[5] as CardDigimon, card6Rivalx, card6Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, battleCardGame.rival.hand.cards[5].internalGameId!)
        : CardEquipmentWidget(battleCardGame.rival.hand.cards[5] as CardEquipment, card6Rivalx, card6Rivaly, true, addSelectedCard, true, isEnabledToActivaEquipmentCard, activateEquipment, battleCardGame.rival.hand.cards[5].internalGameId!);
  }

  void revealPlayerCards(){
    card1.isHidden = true;
    card2.isHidden = true;
    card3.isHidden = true;
    card4.isHidden = true;
    card5.isHidden = true;
    card6.isHidden = true;
  }

  void addCards() async{
    add(card1);
    add(card2);
    add(card3);
    add(card4);
    add(card5);
    add(card6);
    add(card1Rival);
    add(card2Rival);
    add(card3Rival);
    add(card4Rival);
    add(card5Rival);
    add(card6Rival);
  }

  void updateCards(){
    card1.update(1);
    card2.update(1);
    card3.update(1);
    card4.update(1);
    card5.update(1);
    card6.update(1);
    card1Rival.update(1);
    card2Rival.update(1);
    card3Rival.update(1);
    card4Rival.update(1);
    card5Rival.update(1);
    card6Rival.update(1);
  }

  void removeAllCards(){
    if (card1.isMounted){
      remove(card1);
    }
    if (card2.isMounted){
      remove(card2);
    }
    if (card3.isMounted){
      remove(card3);
    }
    if (card4.isMounted){
      remove(card4);
    }
    if (card5.isMounted){
      remove(card5);
    }
    if (card6.isMounted){
      remove(card6);
    }
    if (card1Rival.isMounted){
      remove(card1Rival);
    }
    if (card2Rival.isMounted){
      remove(card2Rival);
    }
    if (card3Rival.isMounted){
      remove(card3Rival);
    }
    if (card4Rival.isMounted){
      remove(card4Rival);
    }
    if (card5Rival.isMounted){
      remove(card5Rival);
    }
    if (card6Rival.isMounted){
      remove(card6Rival);
    }
  }

  void removeNotSummonedCardsByPlayer(){
    if (isEnabledToSummonDigimonCard(card1.internalCardId!) && !battleCardGame.player.wasSelectedCard(card1.internalCardId!)){
      card1.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(card2.internalCardId!) && !battleCardGame.player.wasSelectedCard(card2.internalCardId!)){
      card2.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(card3.internalCardId!) && !battleCardGame.player.wasSelectedCard(card3.internalCardId!)){
      card3.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(card4.internalCardId!) && !battleCardGame.player.wasSelectedCard(card4.internalCardId!)){
      card4.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(card5.internalCardId!) && !battleCardGame.player.wasSelectedCard(card5.internalCardId!)){
      card5.removeFromParent();
    }

    if (isEnabledToSummonDigimonCard(card6.internalCardId!) && !battleCardGame.player.wasSelectedCard(card6.internalCardId!)){
      card6.removeFromParent();
    }

  }

  void removeNotSummonedCardsByRival(){
    if (isEnabledToSummonDigimonCardRival(card1Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card1Rival.internalCardId!)){
      card1Rival.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(card2Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card2Rival.internalCardId!)){
      card2Rival.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(card3Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card3Rival.internalCardId!)){
      card3Rival.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(card4Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card4Rival.internalCardId!)){
      card4Rival.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(card5Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card5Rival.internalCardId!)){
      card5Rival.removeFromParent();
    }

    if (isEnabledToSummonDigimonCardRival(card6Rival.internalCardId!) && !battleCardGame.rival.wasSelectedCard(card6Rival.internalCardId!)){
      card6Rival.removeFromParent();
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
