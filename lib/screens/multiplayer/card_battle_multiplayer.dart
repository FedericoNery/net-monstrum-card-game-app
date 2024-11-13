import 'dart:convert';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart' as material;
import 'package:net_monstrum_card_game/adapters/battle_card_game_adapter.dart';
import 'package:net_monstrum_card_game/communication/socket_events_names.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/digimon_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/factories/card_widget_factory.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';
import 'package:net_monstrum_card_game/services/socket_client.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/ap_hp.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/left_side_section.dart';
import 'package:net_monstrum_card_game/widgets/shared/fading_text.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../domain/card/equipment_effect.dart';
import '../../widgets/card_battle/color_counter.dart';
import '../../widgets/card_battle/counters_cards_section.dart';
import '../../widgets/card_battle/texts_counters_player.dart';
import '../../widgets/card_battle/victory_message.dart';
import '../../widgets/shared/button.dart';
import '../singleplayer/rounded_rectangle_component.dart';

class CardBattleMultiplayer extends World
    with
        HasGameRef,
        FlameBlocListenable<CardBattleMultiplayerBloc,
            CardBattleMultiplayerState> {
  IO.Socket socket = SocketManager().socket!;
  BattleCardGameAdapter battleCardGameAdapter = BattleCardGameAdapter();

  late ParallaxComponent backgroundParallax;

  final enabledMusic = false;
  late AudioPool pool;
  late VictoryMessage victoryMessage;

  late CardWidgetFactory playerCards;
  late CardWidgetFactory rivalCards;

  final summonDigimonButton = InGameButton('Invocar Digimon');
  final activateEquipmentButton = InGameButton('Activar Equipamiento');
  final confirmCompilationPhaseButton =
      InGameButton('Confirmar fase de compilación');
  final confirmUpgradePhaseButton = InGameButton('Confirmar fase de mejora');

  final ColorCounterInstances colorCounterInstances = ColorCounterInstances();
  final ApHPInstances apHpInstances = ApHPInstances();

  final CountersCardsSectionPlayer countersCardsSectionPlayer =
      CountersCardsSectionPlayer();
  final CountersCardsSectionRival countersCardsSectionRival =
      CountersCardsSectionRival();

  final LeftSideSectionRival leftSideSectionRival = LeftSideSectionRival();
  final LeftSideSectionPlayer leftSideSectionPlayer = LeftSideSectionPlayer();

  late TextComponent roundsWinPlayer;
  late TextComponent roundsWinRival;
  late FadingTextComponent fadingText;

  Function redirectToHomePage;

  late RectanguloRedondeadoComponent inferiorBar =
      RectanguloRedondeadoComponent(
          color: const material.Color.fromRGBO(141, 149, 158, 1),
          top: 365,
          left: 100,
          width: 510,
          height: 35,
          borderRadius: 4);

  late RectanguloRedondeadoComponent inferiorBarApHp =
      RectanguloRedondeadoComponent(
          color: const material.Color.fromRGBO(141, 149, 158, 1),
          top: 365,
          left: 630,
          width: 120,
          height: 35,
          borderRadius: 4);
  late RectanguloRedondeadoComponent inferiorBar2 =
      RectanguloRedondeadoComponent(
          color: const material.Color.fromRGBO(141, 149, 158, 1),
          top: 0,
          left: 100,
          width: 510,
          height: 35,
          borderRadius: 4);

  late RectanguloRedondeadoComponent inferiorBarApHp2 =
      RectanguloRedondeadoComponent(
          color: const material.Color.fromRGBO(141, 149, 158, 1),
          top: 0,
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

  int? selectedEquipmentCardIndex;
  List<EquipmentEffect> equipmentsEffectSelected = [];
  List<DigimonCardComponent> digimonCardCompomponents = [];
  double screenSizeWidth;

  CardBattleMultiplayer(this.screenSizeWidth, this.redirectToHomePage) {
    socket.on("UPDATE GAME DATA", (data) {
      updateBattleCardGameBloc(data);
    });

    socket.on("AFTER ACTIVATED EQUIPMENT", (data) {
      var jsonMap = json.decode(data);
      Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);
      var cardId = flutterMap["cardEquipmentId"];
      removeCardAfterEquipmentActivation(cardId);
    });

    socket.on("START_BATTLE", (data) {
      fadingText.addText("Fase de batalla");
      updateBattleCardGameBloc(data);
    });

    socket.on("PLAYER 1 ATTACKS", (data) {
      //TODO ANIMACION ATAQUE
      updateBattleCardGameBloc(data);
    });

    socket.on("PLAYER 2 ATTACKS", (data) {
      //TODO ANIMACION ATAQUE
      updateBattleCardGameBloc(data);
    });

    socket.on('finish battle phase', (data) {
      //AGREGAR CARTEL O ALGO QUE INDIQUE GANADOR DE LA RONDA
      updateBattleCardGameBloc(data);
    });

    socket.on("finished game", (data) {});

    socket.on("START NEXT ROUND", (data) {
      fadingText.addText("Próxima ronda");
      //removeAllCards();
      resetLocalStateBloc(data);
    });

    socket.on('start compile phase', (data) {
      /* if (bloc.state.battleCardGame.isDrawPhase() &&
          bloc.state.battleCardGame.drawedCards &&
          addedCardsToUi &&
          !drawCardsEffectWasApplied) {
        playerCards.applyDrawEffect();
        drawCardsEffectWasApplied = true;
        bloc.add(ToCompilationPhase());
        fadingText.addText("Compilation Phase");
      } */
    });

    socket.on("start summon phase", (data) {
      add(summonDigimonButton);
    });
  }

  void updateBattleCardGameBloc(data) {
    var jsonMap = json.decode(data);
    Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);

    //socket.id! == flutterMap["gameData"]["socketIdUsuarioB"]
    BattleCardGameFromJSON battleCardGameFromJSON =
        battleCardGameAdapter.getBattleCardGameFromSocket(
            data, socket.id! == flutterMap["gameData"]["socketIdUsuarioA"]);

    bloc.add(UpdateHandAndDeckAfterDrawedPhase(battleCardGameFromJSON));
  }

  void resetLocalStateBloc(data) {
    var jsonMap = json.decode(data);
    Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);

    //socket.id! == flutterMap["gameData"]["socketIdUsuarioB"]
    BattleCardGameFromJSON battleCardGameFromJSON =
        battleCardGameAdapter.getBattleCardGameFromSocket(
            data, socket.id! == flutterMap["gameData"]["socketIdUsuarioA"]);

    bloc.add(ResetLocalState(battleCardGameFromJSON));
  }

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

    fadingText = FadingTextComponent(
        screenWidth: screenSizeWidth /
            850, //TODO REEMPLAZAR POR EL VALOR QUE LE PASE AL CONSTRUCTOR
        scale: Vector2.all(0.6),
        size: Vector2.all(10.0),
        position: Vector2(0, 185));

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

    summonDigimonButton.position = Vector2(650, 175);
    summonDigimonButton.size = Vector2(100, 50);
    summonDigimonButton.tapUpCallback = summonToDigimonZone;

    activateEquipmentButton.position = Vector2(650, 175);
    activateEquipmentButton.size = Vector2(100, 50);
    activateEquipmentButton.tapUpCallback = nextToBattlePhase;

    confirmCompilationPhaseButton.position = Vector2(650, 175);
    confirmCompilationPhaseButton.size = Vector2(100, 50);
    confirmCompilationPhaseButton.tapUpCallback = confirmCompilationPhase;

    confirmUpgradePhaseButton.position = Vector2(650, 175);
    confirmUpgradePhaseButton.size = Vector2(100, 50);
    confirmUpgradePhaseButton.tapUpCallback = confirmUpgradePhase;

    await add(inferiorBar);
    await add(inferiorBarApHp);
    await add(inferiorBar2);
    await add(inferiorBarApHp2);

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
    await add(apHpInstances.apRival);
    await add(apHpInstances.hpRival);
    await add(apHpInstances.apPlayer);
    await add(apHpInstances.hpPlayer);

    await add(leftSideSectionRival.firstLayer);
    await add(leftSideSectionRival.secondLayer);
    await add(leftSideSectionRival.thirdLayer);

    await add(leftSideSectionPlayer.firstLayer);
    await add(leftSideSectionPlayer.secondLayer);
    await add(leftSideSectionPlayer.thirdLayer);

    await add(countersCardsSectionPlayer.secondaryLayer);
    await add(countersCardsSectionPlayer.firstLayer);
    await add(countersCardsSectionPlayer.deckPlayer);
    await add(countersCardsSectionPlayer.discardPlayer);
    await add(countersCardsSectionPlayer.handPlayer);

    await add(countersCardsSectionRival.secondaryLayer);
    await add(countersCardsSectionRival.firstLayer);
    await add(countersCardsSectionRival.deckRival);
    await add(countersCardsSectionRival.discardRival);
    await add(countersCardsSectionRival.handRival);

    await add(confirmCompilationPhaseButton);
    await add(fadingText);
    await add(roundsWinPlayer);
    await add(roundsWinRival);
  }

  @override
  void onNewState(CardBattleMultiplayerState state) async {
    if (state.battleCardGame.isUpgradePhase()) {
      updateDigimonCardsOnDigimonZone(state.battleCardGame.player.digimonZone,
          state.battleCardGame.rival.digimonZone);
    }

    if (state.battleCardGame.isDrawPhase() &&
        state.battleCardGame.decksShuffled &&
        state.battleCardGame.drawedCards &&
        !addedCardsToUi) {
      playerCards = CardWidgetFactory(state.battleCardGame.player, false);
      rivalCards = CardWidgetFactory(state.battleCardGame.rival, true);
      addCards();
      addedCardsToUi = true;
    }

    if (summonDigimonButton.isMounted &&
        state.battleCardGame.playerSummonedDigimons) {
      remove(this.summonDigimonButton);
      playerCards.deselectCards();
    }

    if (state.battleCardGame.isUpgradePhase() && !removedNotSummonedCards) {
      fadingText.addText("Fase de mejora");
      removeNotSummonedCardsByPlayer();
      playerCards.deselectCards();
      removeNotSummonedCardsByRival();
      rivalCards.revealSelectedCards();

      removedNotSummonedCards = true;

      add(confirmUpgradePhaseButton);
      //remove(summonDigimonButton);
      //add(activateEquipmentButton);
    }

    if (state.battleCardGame.isFinishedRound() &&
        !state.battleCardGame.battleIsFinished()) {
      removeAllCards();
      //remove(activateEquipmentButton);
      add(confirmCompilationPhaseButton);
      addedCardsToUi = false;
      removedNotSummonedCards = false;
      drawCardsEffectWasApplied = false;
      //bloc.add(ToDrawPhase());
    }

    if (state.battleCardGame.battleIsFinished()) {
      //TODO Remover todos los elementos visuales
      removeAllCards();
      if (state.battleCardGame.isPlayerWinner()) {
        fadingText.addText("Ganaste");
      } else {
        fadingText.addText("Perdiste");
      }
      //remove(activateEquipmentButton);
      await Future.delayed(const Duration(seconds: 3));
      socket.disconnect(); // VER SI SIRVE ESTO
      redirectToHomePage();
    }

    if (state.battleCardGame.isUpgradePhase() &&
        state.battleCardGame.wasSummonedDigimonSpecially) {
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

    //bloc.add(FinishedSpecialSummonDigimon());
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
      bloc.add(const DrawCards());
      fadingText.addText("Fase de reparto");
    }

/*     if (bloc.state.battleCardGame.isDrawPhase() &&
        !bloc.state.battleCardGame.decksShuffled) {
      bloc.add(ShuffleDeck());
      fadingText.addText("Shuffle");
    } */

    if (bloc.state.battleCardGame.isDrawPhase() &&
        bloc.state.battleCardGame.drawedCards &&
        addedCardsToUi &&
        !drawCardsEffectWasApplied) {
      playerCards.applyDrawEffect();
      drawCardsEffectWasApplied = true;
      bloc.add(const ToCompilationPhase());
      fadingText.addText("Fase de compilación");
    }

    apHpInstances.updateValues(bloc.state.battleCardGame);

    roundsWinPlayer.text = 'W:${bloc.state.battleCardGame.player.roundsWon}';
    roundsWinRival.text = 'W:${bloc.state.battleCardGame.rival.roundsWon}';

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

    removeEnergyCardIfWasActivated();
  }

  void removeEnergyCardIfWasActivated() {
    int? activatedEnergyCardId =
        bloc.state.battleCardGame.activatedEnergyCardId;

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
    socket.emit(PlayerActions.FINISH_COMPILATION_PHASE, {
      "socketId": socket.id,
      "usuarioId": bloc.state.battleCardGame.player.username,
    });

    remove(confirmCompilationPhaseButton);
    //bloc.add(ConfirmCompilationPhase());
  }

  void confirmUpgradePhase() {
    socket.emit(PlayerActions.FINISH_UPGRADE_PHASE, {
      "socketId": socket.id,
      "usuarioId": bloc.state.battleCardGame.player.username,
    });

    remove(confirmUpgradePhaseButton);
  }

  void nextToBattlePhase() {
    battlePhase();
  }

  void summonToDigimonZone() {
    socket.emit(PlayerActions.SUMMON_DIGIMONS, {
      "socketId": socket.id,
      "usuarioId": bloc.state.battleCardGame.player.username,
      "cardDigimonsToSummonIds":
          bloc.state.battleCardGame.player.hand.selectedCardsInternalIds,
    });
    //AGREGAR BOTON CUANDO FINALIZA LA SUMMON PHASE
    //add(confirmUpgradePhaseButton);
  }

  void removeCardAfterEquipmentActivation(int cardId) {
    if (playerCards.card1.isMounted &&
        playerCards.card1.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card1);
    }
    if (playerCards.card2.isMounted &&
        playerCards.card2.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card2);
    }
    if (playerCards.card3.isMounted &&
        playerCards.card3.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card3);
    }
    if (playerCards.card4.isMounted &&
        playerCards.card4.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card4);
    }
    if (playerCards.card5.isMounted &&
        playerCards.card5.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card5);
    }
    if (playerCards.card6.isMounted &&
        playerCards.card6.card!.uniqueIdInGame == cardId) {
      remove(playerCards.card6);
    }
  }

  void battlePhase() async {
    //bloc.add(BattlePhaseInit());
    await Future.delayed(const Duration(seconds: 3));

    //bloc.add(BattlePhasePlayerAttacksRival());
    await Future.delayed(const Duration(seconds: 3));

    //bloc.add(BattlePhaseRivalAttacksPlayer());
    await Future.delayed(const Duration(seconds: 3));

    //bloc.add(BattlePhaseFinishRound());
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
    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card1.getUniqueCardId()) &&
        rivalCards.card1.isMounted) {
      rivalCards.card1.removeFromParent();
    }

    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card2.getUniqueCardId()) &&
        rivalCards.card2.isMounted) {
      rivalCards.card2.removeFromParent();
    }

    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card3.getUniqueCardId()) &&
        rivalCards.card3.isMounted) {
      rivalCards.card3.removeFromParent();
    }

    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card4.getUniqueCardId()) &&
        rivalCards.card4.isMounted) {
      rivalCards.card4.removeFromParent();
    }

    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card5.getUniqueCardId()) &&
        rivalCards.card5.isMounted) {
      rivalCards.card5.removeFromParent();
    }

    if (bloc.state.battleCardGame.rival
            .wasDiscarded(rivalCards.card6.getUniqueCardId()) &&
        rivalCards.card6.isMounted) {
      rivalCards.card6.removeFromParent();
    }
  }

  void updateDigimonCardsOnDigimonZone(
      DigimonZone digimonZonePlayer, DigimonZone digimonZoneRival) {
    playerCards.updateCurrentPoints(digimonZonePlayer);
    rivalCards.updateCurrentPoints(digimonZoneRival);
  }
}
