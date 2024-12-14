import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart' as cardBase;
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/card_battle_component.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/rounded_rectangle_component.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/singleplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/ap_hp.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/digimon_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/factories/card_widget_factory.dart';
import 'package:net_monstrum_card_game/widgets/shared/fading_text.dart';
import 'package:net_monstrum_card_game/widgets/shared/fading_text_queue.dart';

import '../../domain/card/equipment_effect.dart';
import '../../widgets/card_battle/color_counter.dart';
import '../../widgets/card_battle/texts_counters_player.dart';
import '../../widgets/card_battle/victory_message.dart';
import '../../widgets/shared/button.dart';
import '../../widgets/shared/icon_with_counter.dart';
import 'dart:ui' as ui;

class CardBattle extends World
    with
        HasGameRef<CardBattleComponent>,
        FlameBlocListenable<CardBattleBloc, CardBattleState> {
  late ParallaxComponent backgroundParallax;

  final enabledMusic = false;
  late AudioPool pool;
  late VictoryMessage victoryMessage;

  late CardWidgetFactory playerCards;
  late CardWidgetFactory rivalCards;

/*   final summonDigimonButton = DefaultButton('Summon Digimon');
  final activateEquipmentButton = DefaultButton('Activate Equipment');
  final confirmCompilationPhaseButton =
      DefaultButton('Confirm compilation phase'); */

  final summonDigimonButton = InGameButton('Summon Digimon');
  final activateEquipmentButton = InGameButton('Activate Equipment');
  final confirmCompilationPhaseButton =
      InGameButton('Confirm compilation phase');

  late ApHpText apRival;
  late ApHpText hpRival;
  late ApHpText apPlayer;
  late ApHpText hpPlayer;
  final ColorCounterInstances colorCounterInstances = ColorCounterInstances();
  late TextComponent roundsWinPlayer;
  late TextComponent roundsWinRival;
/*   late List<TextComponent> textsCounters;
  late List<TextComponent> textsCountersRival; */
/*   late TextsCounters texts; */
  late FadingTextComponent fadingText;
  late FadingTextQueueComponent fadingTextQueueComponent;

  RectangleComponent squareBackgroundNumber = RectangleComponent.square(
      position: Vector2.all(10),
      size: 20,
      paint: Paint()..color = Colors.blueGrey.shade900);

  RectangleComponent squareBackgroundColor = RectangleComponent.square(
      position: Vector2.all(50),
      size: 20,
      paint: Paint()..color = Colors.blueGrey.shade900);

  RectanguloRedondeadoComponent inferiorBar = RectanguloRedondeadoComponent(
      color: Color.fromRGBO(141, 149, 158, 1),
      top: 365,
      left: 100,
      width: 510,
      height: 35,
      borderRadius: 4);

  RectanguloRedondeadoComponent inferiorBarApHp = RectanguloRedondeadoComponent(
      color: Color.fromRGBO(141, 149, 158, 1),
      top: 365,
      left: 630,
      width: 120,
      height: 35,
      borderRadius: 4);

  bool addedCardsToUi = false;
  bool removedNotSummonedCards = false;
  bool drawCardsEffectWasApplied = false;
  int? activatedEnergyCardId;
  int? activatedEquipmentCardId;

  double xLastPositionCard = 600;
  double yLastPositionCard = 250;
  double screenSizeWidth;
  CardBattle(this.screenSizeWidth);

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
    /* if (enabledMusic) {
      startBgmMusic();
    } */

    fadingText = FadingTextComponent(
        screenWidth: screenSizeWidth / 850,
        scale: Vector2.all(0.6),
        size: Vector2.all(10.0),
        position: Vector2(0, 185));

    fadingTextQueueComponent =
        FadingTextQueueComponent(screenWidth: screenSizeWidth / 850);

    victoryMessage = VictoryMessage();

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

    /*   apRival = TextComponent(
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
    ); */

    summonDigimonButton.position = Vector2(650, 175);
    summonDigimonButton.size = Vector2(100, 50);
    summonDigimonButton.tapUpCallback = nextPhase;

    activateEquipmentButton.position = Vector2(650, 175);
    activateEquipmentButton.size = Vector2(100, 50);
    activateEquipmentButton.tapUpCallback = nextToBattlePhase;

    confirmCompilationPhaseButton.position = Vector2(650, 175);
    confirmCompilationPhaseButton.size = Vector2(100, 50);
    confirmCompilationPhaseButton.tapUpCallback = confirmCompilationPhase;

    await add(inferiorBar);
    await add(inferiorBarApHp);

    RectanguloRedondeadoComponent inferiorBar2 = RectanguloRedondeadoComponent(
        color: Color.fromRGBO(141, 149, 158, 1),
        top: 0,
        left: 100,
        width: 510,
        height: 35,
        borderRadius: 4);

    RectanguloRedondeadoComponent inferiorBarApHp2 =
        RectanguloRedondeadoComponent(
            color: Color.fromRGBO(141, 149, 158, 1),
            top: 0,
            left: 630,
            width: 120,
            height: 35,
            borderRadius: 4);
    await add(inferiorBar2);
    await add(inferiorBarApHp2);

    RectanguloRedondeadoComponent rect2 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(123, 24, 42, 1),
        top: 0,
        left: 0,
        width: 100,
        height: 200,
        borderRadius: 0);

    await add(rect2);
    RectanguloRedondeadoComponent rect5 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(132, 74, 82, 1),
        top: 105,
        left: 0,
        width: 90,
        height: 90,
        borderRadius: 4);
    await add(rect5);
    RectanguloRedondeadoComponent rect6 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(189, 140, 148, 1),
        top: 110,
        left: 0,
        width: 85,
        height: 80,
        borderRadius: 4);
    await add(rect6);

    RectanguloRedondeadoComponent rect1 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(24, 49, 123, 1),
        top: 200,
        left: 0,
        width: 100,
        height: 200,
        borderRadius: 0);
    await add(rect1);
    RectanguloRedondeadoComponent rect4 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(74, 90, 132, 1),
        top: 205,
        left: 0,
        width: 90,
        height: 90,
        borderRadius: 4);
    await add(rect4);
    RectanguloRedondeadoComponent rect3 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(142, 157, 190, 1),
        top: 210,
        left: 0,
        width: 85,
        height: 80,
        borderRadius: 4);
    await add(rect3);

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
    /* await add(apRival);
    await add(hpRival);
    await add(apPlayer);
    await add(hpPlayer); */
    await add(confirmCompilationPhaseButton);
    await add(fadingText);
    await add(fadingTextQueueComponent);
    apRival = ApHpText(
      x: 620,
      y: 5,
      cantidad: 0,
      text: 'AP',
    );
    apPlayer = ApHpText(
      x: 620,
      y: 370,
      cantidad: 0,
      text: 'AP',
    );
    hpRival = ApHpText(
      x: 670,
      y: 5,
      cantidad: 0,
      text: 'HP',
    );
    hpPlayer = ApHpText(
      x: 670,
      y: 370,
      cantidad: 0,
      text: 'HP',
    );
    await add(apRival);
    await add(hpRival);
    await add(apPlayer);
    await add(hpPlayer);

    IconWithCounter deckPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 240,
        imageUrl: "assets/images/playmat/deck_icon.png");
    IconWithCounter discardPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 280,
        imageUrl: "assets/images/playmat/trash_icon.png");
    IconWithCounter handPlayer = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 320,
        imageUrl: "assets/images/playmat/hand_icon.png");

    RectanguloRedondeadoComponent rect8 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(24, 49, 123, 1),
        top: 225,
        left: 650,
        width: 100,
        height: 140,
        borderRadius: 0);
    await add(rect8);

    RectanguloRedondeadoComponent rect9 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(74, 90, 132, 1),
        top: 230,
        left: 660,
        width: 90,
        height: 130,
        borderRadius: 4);
    await add(rect9);

    await add(deckPlayer);
    await add(discardPlayer);
    await add(handPlayer);

    IconWithCounter deckRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 50,
        imageUrl: "assets/images/playmat/deck_icon.png");
    IconWithCounter discardRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 90,
        imageUrl: "assets/images/playmat/trash_icon.png");
    IconWithCounter handRival = IconWithCounter(
        cantidad: 0,
        x: 670,
        y: 130,
        imageUrl: "assets/images/playmat/hand_icon.png");

    RectanguloRedondeadoComponent rect10 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(123, 24, 42, 1),
        top: 35,
        left: 650,
        width: 100,
        height: 140,
        borderRadius: 0);
    await add(rect10);

    RectanguloRedondeadoComponent rect12 = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(132, 74, 82, 1),
        top: 40,
        left: 660,
        width: 90,
        height: 130,
        borderRadius: 4);
    await add(rect12);

    await add(deckRival);
    await add(discardRival);
    await add(handRival);
  }

  @override
  void onNewState(CardBattleState state) {
    if (state.battleCardGame.isDrawPhase() &&
        state.battleCardGame.decksShuffled &&
        state.battleCardGame.drawedCards &&
        !addedCardsToUi) {
      playerCards = CardWidgetFactory(state.battleCardGame.player, false);
      rivalCards = CardWidgetFactory(state.battleCardGame.rival, true);
      addCards();
      addedCardsToUi = true;
      fadingTextQueueComponent.addText("Repartiendo Cartas");
    }

    if (state.battleCardGame.isUpgradePhase() && !removedNotSummonedCards) {
      fadingText.addText("Upgrade Phase");
      removeNotSummonedCardsByPlayer();
      playerCards.deselectCards();
      removeNotSummonedCardsByRival();
      rivalCards.revealSelectedCards();

      removedNotSummonedCards = true;

      remove(summonDigimonButton);
      add(activateEquipmentButton);
    }

    if (state.battleCardGame.isFinishedRound() &&
        !state.battleCardGame.battleIsFinished()) {
      removeAllCards();
      remove(activateEquipmentButton);
      add(confirmCompilationPhaseButton);
      addedCardsToUi = false;
      removedNotSummonedCards = false;
      drawCardsEffectWasApplied = false;
      bloc.add(ToDrawPhase());
    }

    if (state.battleCardGame.battleIsFinished()) {
      //TODO Remover todos los elementos visuales
      removeAllCards();
      if (state.battleCardGame.isPlayerWinner()) {
        victoryMessage.text = "Ganaste";
      } else {
        victoryMessage.text = "Perdiste";
      }
      add(victoryMessage);
      remove(activateEquipmentButton);
    }

    if (state.battleCardGame.isUpgradePhase() &&
        state.battleCardGame.selectedEquipmentCardId != null &&
        state.battleCardGame.targetDigimonId != null) {
      removeCardAfterEquipmentActivation(state.battleCardGame);
      bloc.add(ClearActivatedEquipmentCard());
    }

    if (state.battleCardGame.isUpgradePhase() &&
        state.battleCardGame.wasSummonedDigimonSpecially) {
      updateDigimonZoneOnSummonDigimon(state.battleCardGame.player.digimonZone);
    }
  }

  void updateDigimonZoneOnSummonDigimon(DigimonZone digimonZone) {
    List<CardDigimon> cards = digimonZone.cards;

    cardBase.Card? card1 = playerCards.card1.card;
    cardBase.Card? card2 = playerCards.card2.card;
    cardBase.Card? card3 = playerCards.card3.card;
    cardBase.Card? card4 = playerCards.card4.card;
    cardBase.Card? card5 = playerCards.card5.card;
    cardBase.Card? card6 = playerCards.card6.card;
    List<int?> cardsIdsList = [
      card1?.uniqueIdInGame,
      card2?.uniqueIdInGame,
      card3?.uniqueIdInGame,
      card4?.uniqueIdInGame,
      card5?.uniqueIdInGame,
      card6?.uniqueIdInGame,
    ];

    for (var i = 0; i < cards.length; i++) {
      if (!cardsIdsList.contains(cards[i].uniqueIdInGame) &&
          cards[i].uniqueIdInGame != null) {
        addToUINewDigimonCard(cards[i]);
      }
    }

    bloc.add(FinishedSpecialSummonDigimon());
  }

  void addToUINewDigimonCard(CardDigimon cardDigimon) {
    DigimonCardComponent dcc = DigimonCardComponent(
        cardDigimon, xLastPositionCard, yLastPositionCard, false, false);
    add(dcc);
    digimonCardCompomponents.add(dcc);
    xLastPositionCard = xLastPositionCard + 70;
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('sounds/card-battle-theme.mp3');
  }

  void addCards() {
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (bloc.state.battleCardGame.isDrawPhase() &&
        bloc.state.battleCardGame.decksShuffled &&
        !bloc.state.battleCardGame.drawedCards) {
      bloc.add(DrawCards());
      fadingText.addText("Draw Phase");
    }

    if (bloc.state.battleCardGame.isDrawPhase() &&
        !bloc.state.battleCardGame.decksShuffled) {
      bloc.add(ShuffleDeck());
      fadingText.addText("Shuffle");
    }

    if (bloc.state.battleCardGame.isDrawPhase() &&
        bloc.state.battleCardGame.drawedCards &&
        addedCardsToUi &&
        !drawCardsEffectWasApplied) {
      playerCards.applyDrawEffect();
      drawCardsEffectWasApplied = true;
      bloc.add(ToCompilationPhase());
      fadingText.addText("Compilation Phase");
    }

    int? activatedEnergyCardId =
        bloc.state.battleCardGame.activatedEnergyCardId;

    colorCounterInstances.blackCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.black;
    colorCounterInstances.blueCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.blue;
    colorCounterInstances.brownCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.brown;
    colorCounterInstances.greenCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.green;
    colorCounterInstances.redCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.red;
    colorCounterInstances.whiteCounter.cantidad =
        bloc.state.battleCardGame.player.energiesCounters.white;

    colorCounterInstances.blackCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.black;
    colorCounterInstances.blueCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.blue;
    colorCounterInstances.brownCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.brown;
    colorCounterInstances.greenCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.green;
    colorCounterInstances.redCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.red;
    colorCounterInstances.whiteCounterRival.cantidad =
        bloc.state.battleCardGame.rival.energiesCounters.white;

    /*  apRival.cantidad = bloc.state.battleCardGame.rival.attackPoints;
    hpRival.cantidad = bloc.state.battleCardGame.rival.healthPoints;
    apPlayer.cantidad = bloc.state.battleCardGame.player.attackPoints;
    hpPlayer.cantidad = bloc.state.battleCardGame.player.healthPoints; */

    apRival.updateCantidad(bloc.state.battleCardGame.rival.attackPoints);
    hpRival.updateCantidad(bloc.state.battleCardGame.rival.healthPoints);

    apPlayer.updateCantidad(bloc.state.battleCardGame.player.attackPoints);
    hpPlayer.updateCantidad(bloc.state.battleCardGame.player.healthPoints);

    roundsWinPlayer.text = 'W:${bloc.state.battleCardGame.player.roundsWon}';
    roundsWinRival.text = 'W:${bloc.state.battleCardGame.rival.roundsWon}';

    if (addedCardsToUi) {
      if (playerCards.card1.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card1.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card1);
      }
      if (playerCards.card2.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card2.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card2);
      }
      if (playerCards.card3.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card3.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card3);
      }
      if (playerCards.card4.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card4.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card4);
      }
      if (playerCards.card5.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card5.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card5);
      }
      if (playerCards.card6.getUniqueCardId() == activatedEnergyCardId &&
          playerCards.card6.card!.isDigimonOrEnergyCard()) {
        remove(playerCards.card6);
      }
    }
  }

  void confirmCompilationPhase() {
    remove(confirmCompilationPhaseButton);
    add(summonDigimonButton);
    bloc.add(ConfirmCompilationPhase());
  }

  void passPhase() {}

  void nextToBattlePhase() {
    battlePhase();
    fadingTextQueueComponent.addText("Luchar...");
  }

  void nextPhase() {
    bloc.add(SummonDigimonCardsToDigimonZone());
    fadingTextQueueComponent.addText("Proxima fase...");
  }

  void removeCardAfterEquipmentActivation(BattleCardGame battleCardGame) {
    if (playerCards.card1.isMounted &&
        playerCards.card1.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted &&
        playerCards.card2.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted &&
        playerCards.card3.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted &&
        playerCards.card4.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted &&
        playerCards.card5.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted &&
        playerCards.card6.card!.uniqueIdInGame ==
            battleCardGame.selectedEquipmentCardId) {
      remove(playerCards.card6);
    }
  }

  void battlePhase() async {
    removeCardsBeforeBattlePhaseStart();
    bloc.add(BattlePhaseInit());
    await Future.delayed(Duration(seconds: 3));

    bloc.add(BattlePhasePlayerAttacksRival());
    await playerCards.attackAnimation();
    await Future.delayed(Duration(seconds: 5));

    bloc.add(BattlePhaseRivalAttacksPlayer());
    await rivalCards.attackAnimation();
    await Future.delayed(Duration(seconds: 5));

    bloc.add(BattlePhaseFinishRound());
    fadingTextQueueComponent.addText("Batalla finalizada...");
  }

  void removeCardsBeforeBattlePhaseStart() {
    if (playerCards.card1.isMounted &&
        !playerCards.card1.card!.isDigimonCard()) {
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted &&
        !playerCards.card2.card!.isDigimonCard()) {
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted &&
        !playerCards.card3.card!.isDigimonCard()) {
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted &&
        !playerCards.card4.card!.isDigimonCard()) {
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted &&
        !playerCards.card5.card!.isDigimonCard()) {
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted &&
        !playerCards.card6.card!.isDigimonCard()) {
      remove(playerCards.card6);
    }

    if (rivalCards.card1.isMounted && !rivalCards.card1.card!.isDigimonCard()) {
      remove(rivalCards.card1);
    }
    if (rivalCards.card2.isMounted && !rivalCards.card2.card!.isDigimonCard()) {
      remove(rivalCards.card2);
    }
    if (rivalCards.card3.isMounted && !rivalCards.card3.card!.isDigimonCard()) {
      remove(rivalCards.card3);
    }
    if (rivalCards.card4.isMounted && !rivalCards.card4.card!.isDigimonCard()) {
      remove(rivalCards.card4);
    }
    if (rivalCards.card5.isMounted && !rivalCards.card5.card!.isDigimonCard()) {
      remove(rivalCards.card5);
    }
    if (rivalCards.card6.isMounted && !rivalCards.card6.card!.isDigimonCard()) {
      remove(rivalCards.card6);
    }
  }

  void removeAllCards() {
    if (playerCards.card1.isMounted) {
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted) {
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted) {
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted) {
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted) {
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted) {
      remove(playerCards.card6);
    }
    if (rivalCards.card1.isMounted) {
      remove(rivalCards.card1);
    }
    if (rivalCards.card2.isMounted) {
      remove(rivalCards.card2);
    }
    if (rivalCards.card3.isMounted) {
      remove(rivalCards.card3);
    }
    if (rivalCards.card4.isMounted) {
      remove(rivalCards.card4);
    }
    if (rivalCards.card5.isMounted) {
      remove(rivalCards.card5);
    }
    if (rivalCards.card6.isMounted) {
      remove(rivalCards.card6);
    }

    for (final digimonCardComponent in digimonCardCompomponents) {
      if (digimonCardComponent.isMounted) {
        remove(digimonCardComponent);
      }
    }
  }

  void removeNotSummonedCardsByPlayer() {
    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card1.getUniqueCardId()) &&
        playerCards.card1.isMounted &&
        playerCards.card1.card!.isDigimonOrEnergyCard()) {
      playerCards.card1.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card2.getUniqueCardId()) &&
        playerCards.card2.isMounted &&
        playerCards.card2.card!.isDigimonOrEnergyCard()) {
      playerCards.card2.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card3.getUniqueCardId()) &&
        playerCards.card3.isMounted &&
        playerCards.card3.card!.isDigimonOrEnergyCard()) {
      playerCards.card3.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card4.getUniqueCardId()) &&
        playerCards.card4.isMounted &&
        playerCards.card4.card!.isDigimonOrEnergyCard()) {
      playerCards.card4.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card5.getUniqueCardId()) &&
        playerCards.card5.isMounted &&
        playerCards.card5.card!.isDigimonOrEnergyCard()) {
      playerCards.card5.removeFromParent();
    }

    if (!bloc.state.battleCardGame.player
            .wasSelectedCard(playerCards.card6.getUniqueCardId()) &&
        playerCards.card6.isMounted &&
        playerCards.card6.card!.isDigimonOrEnergyCard()) {
      playerCards.card6.removeFromParent();
    }
  }

  void removeNotSummonedCardsByRival() {
    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card1.getUniqueCardId()) &&
        rivalCards.card1.isMounted) {
      rivalCards.card1.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card2.getUniqueCardId()) &&
        rivalCards.card2.isMounted) {
      rivalCards.card2.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card3.getUniqueCardId()) &&
        rivalCards.card3.isMounted) {
      rivalCards.card3.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card4.getUniqueCardId()) &&
        rivalCards.card4.isMounted) {
      rivalCards.card4.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card5.getUniqueCardId()) &&
        rivalCards.card5.isMounted) {
      rivalCards.card5.removeFromParent();
    }

    if (!bloc.state.battleCardGame.rival
            .wasSelectedCard(rivalCards.card6.getUniqueCardId()) &&
        rivalCards.card6.isMounted) {
      rivalCards.card6.removeFromParent();
    }
  }
}
