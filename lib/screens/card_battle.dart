import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/digimon_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/factories/card_widget_factory.dart';
import 'package:net_monstrum_card_game/widgets/shared/fading_text.dart';
import '../domain/card/equipment_effect.dart';
import '../widgets/card_battle/color_counter.dart';
import '../widgets/card_battle/texts_counters_player.dart';
import '../widgets/card_battle/victory_message.dart';
import '../widgets/shared/background_image.dart';
import '../widgets/shared/button.dart';
import 'package:flame_audio/flame_audio.dart';

class CardBattle extends PositionComponent
  with HasGameRef, FlameBlocListenable<CardBattleBloc, CardBattleState> {
  final background = BackgroundImage("playmat/playmat.png");

  final enabledMusic = false;
  late AudioPool pool;
  late VictoryMessage victoryMessage;

  late CardWidgetFactory playerCards;
  late CardWidgetFactory rivalCards;

  final summonDigimonButton = DefaultButton('Summon Digimon');
  final activateEquipmentButton = DefaultButton('Activate Equipment');
  final confirmCompilationPhaseButton = DefaultButton('Confirm compilation phase');
  final passPhaseButton = DefaultButton('Pass');

  late TextComponent apRival;
  late TextComponent hpRival;
  late TextComponent apPlayer;
  late TextComponent hpPlayer;
  final ColorCounterInstances colorCounterInstances = ColorCounterInstances();
  late TextComponent roundsWinPlayer;
  late TextComponent roundsWinRival;
  late List<TextComponent> textsCounters;
  late List<TextComponent> textsCountersRival;
  late TextsCounters texts;
  late FadingTextComponent fadingText;

  bool addedCardsToUi = false;
  bool removedNotSummonedCards = false;
  int? activatedEnergyCardId;
  int? activatedEquipmentCardId;

  double xLastPositionCard = 600;
  double yLastPositionCard = 250;

  CardBattle();

  int? selectedEquipmentCardIndex;
  List<EquipmentEffect> equipmentsEffectSelected = [];
  List<DigimonCardComponent> digimonCardCompomponents = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    pool = await FlameAudio.createPool(
      'sounds/card-battle-theme.mp3',
      minPlayers: 2,
      maxPlayers: 2,
    );
    if (enabledMusic) {
      startBgmMusic();
    }

    fadingText = FadingTextComponent(scale: Vector2.all(0.6),
      size: Vector2.all(10.0),
      position: Vector2(0, 185)
    );

    //TODO ANIMACION
    //battleCardGame.shuffleDeck();

    //TODO ANIMACION
    //battleCardGame.drawCards();

    victoryMessage = VictoryMessage();

    //playerCards = CardWidgetFactory(battleCardGame.player, false, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment, isEnabledToSelectEnergyCard, activateEnergy);
    //rivalCards = CardWidgetFactory(battleCardGame.rival, true, addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment, isEnabledToSelectEnergyCard, activateEnergy);

    texts = TextsCounters();
    //textsCounters = TextsCounters.getComponents(battleCardGame.player.energiesCounters);
    //textsCountersRival = TextsCounters.getRivalComponents(battleCardGame.rival.energiesCounters);

    roundsWinPlayer = TextComponent(
      text: 'W:${0}',
      size: Vector2.all(10.0),
      position: Vector2(0, 370),
    );

    roundsWinRival = TextComponent(
      text: 'W:${0}',
      size: Vector2.all(10.0),
      position: Vector2(0, 0),
    );

    apRival = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 0),
      scale: Vector2.all(0.8),
    );

    hpRival = TextComponent(
      text: 'HP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(700, 0),
      scale: Vector2.all(0.8),
    );

    apPlayer = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 370),
      scale: Vector2.all(0.8),
    );

    hpPlayer = TextComponent(
      text: 'HP:${0}',
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

    confirmCompilationPhaseButton.position = Vector2(650, 50);
    confirmCompilationPhaseButton.size = Vector2(100, 50);
    confirmCompilationPhaseButton.tapUpCallback = confirmCompilationPhase;

    passPhaseButton.position = Vector2(650, 110);
    passPhaseButton.size = Vector2(100, 50);
    passPhaseButton.tapUpCallback = passPhase;

    await add(background);
    await add(colorCounterInstances.blueCounter);
    await add(colorCounterInstances.redCounter);
    await add(colorCounterInstances.brownCounter);
    await add(colorCounterInstances.whiteCounter);
    await add(colorCounterInstances.blackCounter);
    await add(colorCounterInstances.greenCounter);
    await add(colorCounterInstances.blueCounterRival);
    await add(colorCounterInstances.redCounterRival);
    await add(colorCounterInstances.brownCounterRival);
    await add(colorCounterInstances.whiteCounterRival);
    await add(colorCounterInstances.blackCounterRival);
    await add(colorCounterInstances.greenCounterRival);
    await add(roundsWinPlayer);
    await add(roundsWinRival);
    await add(apRival);
    await add(hpRival);
    await add(apPlayer);
    await add(hpPlayer);
    await add(texts.blackCounterText);
    await add(texts.blackCounterTextRival);
    await add(texts.blueCounterText);
    await add(texts.blueCounterTextRival);
    await add(texts.brownCounterText);
    await add(texts.brownCounterTextRival);
    await add(texts.greenCounterText);
    await add(texts.greenCounterTextRival);
    await add(texts.redCounterText);
    await add(texts.redCounterTextRival);
    await add(texts.whiteCounterText);
    await add(texts.whiteCounterTextRival);
    await add(confirmCompilationPhaseButton);
    await add(passPhaseButton);
    await add(fadingText);
  }

  @override
  void onNewState(CardBattleState state) {
    if(state.battleCardGame.isCompilationPhase() && !addedCardsToUi){
      fadingText.addText("Compilation Phase");
      playerCards = CardWidgetFactory(bloc.state.battleCardGame.player, false);
      rivalCards = CardWidgetFactory(bloc.state.battleCardGame.rival, true);
      addCards();
      addedCardsToUi = true;
    }
    
    if(state.battleCardGame.isUpgradePhase() && !removedNotSummonedCards){
      fadingText.addText("Upgrade Phase");
      removeNotSummonedCardsByPlayer();
      playerCards.deselectCards();
      removeNotSummonedCardsByRival();
      rivalCards.revealSelectedCards();

      removedNotSummonedCards = true;

      remove(summonDigimonButton);
      add(activateEquipmentButton);
    }

    if (state.battleCardGame.isFinishedRound() && !state.battleCardGame.battleIsFinished()){
      removeAllCards();
      remove(activateEquipmentButton);
      add(confirmCompilationPhaseButton);
      addedCardsToUi = false;
      removedNotSummonedCards= false;
      bloc.add(ToDrawPhase());
    }

    if (state.battleCardGame.battleIsFinished()){
      //TODO Remover todos los elementos visuales
      removeAllCards();
      if(state.battleCardGame.isPlayerWinner()){
        victoryMessage.text = "Ganaste";
      }
      else{
        victoryMessage.text = "Perdiste";
      }
      add(victoryMessage);
      remove(activateEquipmentButton);
    }

    if(state.battleCardGame.isUpgradePhase() && state.battleCardGame.selectedEquipmentCardId != null
    && state.battleCardGame.targetDigimonId != null){
      removeCardAfterEquipmentActivation(state.battleCardGame);
      bloc.add(ClearActivatedEquipmentCard());
    }

    if(state.battleCardGame.isUpgradePhase() && state.battleCardGame.wasSummonedDigimonSpecially){
      updateDigimonZoneOnSummonDigimon(state.battleCardGame.player.digimonZone);
    }
  }

  void updateDigimonZoneOnSummonDigimon(DigimonZone digimonZone) {
    List<CardDigimon> cards = digimonZone.cards;

    Card? card1 = playerCards.card1.card;
    Card? card2 = playerCards.card2.card;
    Card? card3 = playerCards.card3.card;
    Card? card4 = playerCards.card4.card;
    Card? card5 = playerCards.card5.card;
    Card? card6 = playerCards.card6.card;
    List<int?> cardsIdsList= [
      card1?.uniqueIdInGame, 
      card2?.uniqueIdInGame,
      card3?.uniqueIdInGame,
      card4?.uniqueIdInGame,
      card5?.uniqueIdInGame,
      card6?.uniqueIdInGame,
    ];

    for (var i = 0; i < cards.length; i++) {
      if (!cardsIdsList.contains(cards[i].uniqueIdInGame) && cards[i].uniqueIdInGame != null){
        addToUINewDigimonCard(cards[i]);
      }
    }

    bloc.add(FinishedSpecialSummonDigimon());
  }

  void addToUINewDigimonCard(CardDigimon cardDigimon) {
    DigimonCardComponent dcc = DigimonCardComponent(cardDigimon, xLastPositionCard, yLastPositionCard, false, false);
    add(dcc);
    digimonCardCompomponents.add(dcc);
    xLastPositionCard = xLastPositionCard + 70;
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('sounds/card-battle-theme.mp3');
  }

  void addCards() async {
    await add(playerCards.card1);
    await add(playerCards.card2);
    await add(playerCards.card3);
    await add(playerCards.card4);
    await add(playerCards.card5);
    await add(playerCards.card6);
    await add(rivalCards.card1);
    await add(rivalCards.card2);
    await add(rivalCards.card3);
    await add(rivalCards.card4);
    await add(rivalCards.card5);
    await add(rivalCards.card6);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (bloc.state.battleCardGame.isDrawPhase()) {
      if (bloc.state.battleCardGame.decksNotShuffled()){
        bloc.add(ShuffleDeck());
        fadingText.addText("Shuffle");
      }

      bloc.add(DrawCards());
      fadingText.addText("Draw Phase");
    }

    int? activatedEnergyCardId = bloc.state.battleCardGame.activatedEnergyCardId;

    texts.blackCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.black}';
    texts.blueCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.blue}';
    texts.brownCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.brown}';
    texts.greenCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.green}';
    texts.redCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.red}';
    texts.whiteCounterText.text =
        '${bloc.state.battleCardGame.player.energiesCounters.white}';

    texts.blackCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.black}';
    texts.blueCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.blue}';
    texts.brownCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.brown}';
    texts.greenCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.green}';
    texts.redCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.red}';
    texts.whiteCounterTextRival.text =
        '${bloc.state.battleCardGame.rival.energiesCounters.white}';

    apRival.text = 'AP:${bloc.state.battleCardGame.rival.attackPoints}';
    hpRival.text = 'HP:${bloc.state.battleCardGame.rival.healthPoints}';
    apPlayer.text = 'AP:${bloc.state.battleCardGame.player.attackPoints}';
    hpPlayer.text = 'HP:${bloc.state.battleCardGame.player.healthPoints}';

    roundsWinPlayer.text = 'W:${bloc.state.battleCardGame.player.roundsWon}';
    roundsWinRival.text = 'W:${bloc.state.battleCardGame.rival.roundsWon}';

    if(addedCardsToUi){
      if (playerCards.card1.getUniqueCardId() == activatedEnergyCardId 
      && playerCards.card1.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card1);
      }
      if (playerCards.card2.getUniqueCardId() == activatedEnergyCardId
      && playerCards.card2.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card2);
      }
      if (playerCards.card3.getUniqueCardId() == activatedEnergyCardId
      && playerCards.card3.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card3);
      }
      if (playerCards.card4.getUniqueCardId() == activatedEnergyCardId
      && playerCards.card4.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card4);
      }
      if (playerCards.card5.getUniqueCardId() == activatedEnergyCardId
      && playerCards.card5.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card5);
      }
      if (playerCards.card6.getUniqueCardId() == activatedEnergyCardId
      && playerCards.card6.card!.isDigimonOrEnergyCard()){
        remove(playerCards.card6);
      }
    }
  }

  void confirmCompilationPhase() {
    remove(confirmCompilationPhaseButton);
    add(summonDigimonButton);
    bloc.add(ConfirmCompilationPhase());
  }

  void passPhase(){

  }

  void nextToBattlePhase() {
    battlePhase();
  }

  void nextPhase() {
    bloc.add(SummonDigimonCardsToDigimonZone());
  }

  void removeCardAfterEquipmentActivation(BattleCardGame battleCardGame) {
    if (playerCards.card1.isMounted && playerCards.card1.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted && playerCards.card2.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted && playerCards.card3.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted && playerCards.card4.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted && playerCards.card5.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted && playerCards.card6.card!.uniqueIdInGame == battleCardGame.selectedEquipmentCardId){
      remove(playerCards.card6);
    }
  }

  void battlePhase() async {
    bloc.add(BattlePhaseInit());
    await Future.delayed(Duration(seconds: 5));

    bloc.add(BattlePhasePlayerAttacksRival());
    await Future.delayed(Duration(seconds: 5));
    
    bloc.add(BattlePhaseRivalAttacksPlayer());
    await Future.delayed(Duration(seconds: 5));
    
    bloc.add(BattlePhaseFinishRound());
  }

  void removeAllCards() {
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

    for (final digimonCardComponent in digimonCardCompomponents){
      if (digimonCardComponent.isMounted){
        remove(digimonCardComponent);
      }
    }
  }

  void removeNotSummonedCardsByPlayer() {
    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card1.getUniqueCardId())
    && playerCards.card1.isMounted
    && playerCards.card1.card!.isDigimonOrEnergyCard()){
      playerCards.card1.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card2.getUniqueCardId())
    && playerCards.card2.isMounted
    && playerCards.card2.card!.isDigimonOrEnergyCard()){
      playerCards.card2.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card3.getUniqueCardId())
    && playerCards.card3.isMounted
    && playerCards.card3.card!.isDigimonOrEnergyCard()){
      playerCards.card3.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card4.getUniqueCardId())
    && playerCards.card4.isMounted
    && playerCards.card4.card!.isDigimonOrEnergyCard()){
      playerCards.card4.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card5.getUniqueCardId())
    && playerCards.card5.isMounted
    && playerCards.card5.card!.isDigimonOrEnergyCard()){
      playerCards.card5.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player.wasSelectedCard(playerCards.card6.getUniqueCardId())
    && playerCards.card6.isMounted
    && playerCards.card6.card!.isDigimonOrEnergyCard()){
      playerCards.card6.removeFromParent();
    }
  }

  void removeNotSummonedCardsByRival() {
     if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card1.getUniqueCardId())
     && rivalCards.card1.isMounted){
      rivalCards.card1.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card2.getUniqueCardId())
    && rivalCards.card2.isMounted){
      rivalCards.card2.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card3.getUniqueCardId())
    && rivalCards.card3.isMounted){
      rivalCards.card3.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card4.getUniqueCardId())
    && rivalCards.card4.isMounted){
      rivalCards.card4.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card5.getUniqueCardId())
    && rivalCards.card5.isMounted){
      rivalCards.card5.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival.wasSelectedCard(rivalCards.card6.getUniqueCardId())
    && rivalCards.card6.isMounted){
      rivalCards.card6.removeFromParent();
    }
  }

}
