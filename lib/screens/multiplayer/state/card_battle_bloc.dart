import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
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
      List<Card> deckPlayer = event.deckPlayer;
      List<Card> handPlayer = event.handPlayer;
      List<Card> deckRival = event.deckRival;
      List<Card> handRival = event.handRival;
      EnergiesCounters energiesPlayer = event.energiesPlayer;
      EnergiesCounters energiesRival = event.energiesRival;
      String phaseGame = event.phaseGame;
      bool playerSummonedDigimons = event.playerSummonedDigimons;

      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.player.hand.cards = handPlayer;
      battleCardGame.player.deck.cards = deckPlayer;
      battleCardGame.player.energiesCounters = energiesPlayer;

      battleCardGame.rival.hand.cards = handRival;
      battleCardGame.rival.deck.cards = deckRival;
      battleCardGame.rival.energiesCounters = energiesRival;

      battleCardGame.decksShuffled = true; //GENERAR EVENTO DIFERENTE
      battleCardGame.drawedCards = true; //GENERAR EVENTO DIFERENTE

      battleCardGame.phaseGame = phaseGame;
      battleCardGame.playerSummonedDigimons = playerSummonedDigimons;

      battleCardGame.player.attackPoints = event.apPlayer;
      battleCardGame.player.healthPoints = event.hpPlayer;

      battleCardGame.rival.attackPoints = event.apRival;
      battleCardGame.rival.healthPoints = event.hpRival;

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
  }
}
