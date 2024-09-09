import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_monstrum_card_game/adapters/battle_card_game_adapter.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/state/card_battle_state.dart';

class CardBattleMultiplayerBloc
    extends Bloc<CardBattleMultiplayerEvent, CardBattleMultiplayerState> {
  CardBattleMultiplayerBloc(BattleCardGame battleCardGame)
      : super(CardBattleMultiplayerState(battleCardGame)) {
/*     on<WeaponEquipped>(
      (event, emit) => emit(
        state.copyWith(weapon: event.weapon),
      ),
    ); */

    on<UpdateHandAndDeckAfterDrawedPhase>((event, emit) {
      BattleCardGameFromJSON bcgFromJson = event.bcgFromJson;

      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.player.hand.cards = bcgFromJson.playerHandCards;
      battleCardGame.player.deck.cards = bcgFromJson.playerDeckCards;
      battleCardGame.player.digimonZone.cards =
          bcgFromJson.playerDigimonZoneCards;
      battleCardGame.player.trash.cards = bcgFromJson.playerTrashCards;
      battleCardGame.player.energiesCounters = bcgFromJson.energiesPlayer;

      battleCardGame.rival.hand.cards = bcgFromJson.rivalHandCards;
      battleCardGame.rival.deck.cards = bcgFromJson.rivalDeckCards;
      battleCardGame.rival.digimonZone.cards =
          bcgFromJson.rivalDigimonZoneCards;
      battleCardGame.rival.trash.cards = bcgFromJson.rivalTrashCards;

      battleCardGame.rival.energiesCounters = bcgFromJson.energiesRival;

      battleCardGame.decksShuffled = true; //GENERAR EVENTO DIFERENTE
      battleCardGame.drawedCards = true; //GENERAR EVENTO DIFERENTE

      battleCardGame.phaseGame = bcgFromJson.phaseGame;
      battleCardGame.playerSummonedDigimons =
          bcgFromJson.playerSummonedDigimons;

      battleCardGame.player.attackPoints = bcgFromJson.apPlayer;
      battleCardGame.player.healthPoints = bcgFromJson.hpPlayer;

      battleCardGame.rival.attackPoints = bcgFromJson.apRival;
      battleCardGame.rival.healthPoints = bcgFromJson.hpRival;

      battleCardGame.player.roundsWon = bcgFromJson.wonRoundsPlayer;
      battleCardGame.rival.roundsWon = bcgFromJson.wonRoundsRival;

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<ToCompilationPhase>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.toCompilationPhase();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<DrawCards>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.drawedCards = true;
      //battleCardGame.toCompilationPhase();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<SelectDigimonCardFromHandToSummon>((event, emit) {
      int internalCardId = event.cardId;
      BattleCardGame battleCardGame = state.battleCardGame;

      if (battleCardGame.isSummonPhase() &&
          battleCardGame.player.hand
              .isDigimonCardByInternalId(internalCardId)) {
        battleCardGame.player.hand.selectCardByInternalId(internalCardId);
      }

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<SelectEquipmentCardFromHand>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      //AGREGAR QUE SELECCIONÉ LA CARTA DE EQUIPAMIENTO
      battleCardGame.player.selectedEquipmentCardId = event.cardId;
      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<RefuseEquipmentCardFromHand>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.player.selectedEquipmentCardId = null;
      //QUITAR QUE SELECCIONÉ LA CARTA DE EQUIPAMIENTO
      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<ResetLocalState>((event, emit) {
      BattleCardGameFromJSON bcgFromJson = event.bcgFromJson;
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.activatedEnergyCardId = null;
      /* battleCardGame.decksShuffled = true;
      battleCardGame.drawedCards = false; */
      battleCardGame.equipmentsEffectSelected = [];
      battleCardGame.playerSummonedDigimons = false;
      battleCardGame.selectedEquipmentCardId = null;
      battleCardGame.targetDigimonId = null;
      battleCardGame.wasSummonedDigimonSpecially = false;

      battleCardGame.player.hand.cards = bcgFromJson.playerHandCards;
      battleCardGame.player.deck.cards = bcgFromJson.playerDeckCards;
      battleCardGame.player.digimonZone.cards =
          bcgFromJson.playerDigimonZoneCards;
      battleCardGame.player.trash.cards = bcgFromJson.playerTrashCards;
      battleCardGame.player.energiesCounters = bcgFromJson.energiesPlayer;

      battleCardGame.rival.hand.cards = bcgFromJson.rivalHandCards;
      battleCardGame.rival.deck.cards = bcgFromJson.rivalDeckCards;
      battleCardGame.rival.digimonZone.cards =
          bcgFromJson.rivalDigimonZoneCards;
      battleCardGame.rival.trash.cards = bcgFromJson.rivalTrashCards;
      battleCardGame.rival.energiesCounters = bcgFromJson.energiesRival;

      battleCardGame.phaseGame = bcgFromJson.phaseGame;
      battleCardGame.playerSummonedDigimons =
          bcgFromJson.playerSummonedDigimons;

      battleCardGame.player.attackPoints = bcgFromJson.apPlayer;
      battleCardGame.player.healthPoints = bcgFromJson.hpPlayer;

      battleCardGame.rival.attackPoints = bcgFromJson.apRival;
      battleCardGame.rival.healthPoints = bcgFromJson.hpRival;

      battleCardGame.player.roundsWon = bcgFromJson.wonRoundsPlayer;
      battleCardGame.rival.roundsWon = bcgFromJson.wonRoundsRival;

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

/*     on<SelectDigimonCardToBeEquipped>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      //COMO PARAMETRO RECIBE EL ID DE LA CARTA DIGIMON TARGET

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    }); */
  }
}
