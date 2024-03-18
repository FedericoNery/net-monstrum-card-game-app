import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/energy_effect.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/screens/card_battle.dart';
import 'package:net_monstrum_card_game/screens/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';

class CardBattleBloc extends Bloc<CardBattleEvent, CardBattleState> {
  CardBattleBloc(BattleCardGame battleCardGame)
      : super(CardBattleState(battleCardGame)) {
/*     on<WeaponEquipped>(
      (event, emit) => emit(
        state.copyWith(weapon: event.weapon),
      ),
    ); */

    on<ShuffleDeck>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.player.deck.shuffle();
      battleCardGame.rival.deck.shuffle();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));

    });

    on<DrawCards>((event, emit) {
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.drawCards();
      battleCardGame.toCompilationPhase();

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

    on<SelectDigimonCardToBeEquipped>((event, emit) {
      int digimonCardToBeEquippedId = event.cardId;

      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.targetDigimonId = digimonCardToBeEquippedId;
      
      int selectedEquipmentCardId = battleCardGame.selectedEquipmentCardId!;

      battleCardGame.player.hand.removeFromHand(selectedEquipmentCardId);
      battleCardGame.player.digimonZone
          .applyEffectTo(digimonCardToBeEquippedId, battleCardGame.equipmentsEffectSelected.removeLast());
      battleCardGame.player.calculatePoints();
      
      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<SelectEquipmentCardFromHandTo>((event, emit) {
      CardEquipment cardEquipment = event.cardEquipment;

      BattleCardGame battleCardGame = state.battleCardGame;

      if (battleCardGame.isUpgradePhase() &&
          battleCardGame.player.hand.isEquipmentCardByInternalId(cardEquipment.uniqueIdInGame!)) 
      {
        battleCardGame.player.hand.selectCardByInternalId(cardEquipment.uniqueIdInGame!);
        battleCardGame.selectedEquipmentCardId = cardEquipment.uniqueIdInGame!;
        battleCardGame.equipmentsEffectSelected = cardEquipment.getEffects(battleCardGame.player.digimonZone);
      }
      
      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<ActivateEnergyCard>((event, emit){
      CardEnergy cardEnergy = event.cardEnergy;

      BattleCardGame battleCardGame = state.battleCardGame;

      EnergyEffect energyEffect = cardEnergy.getEnergyEffect();
      if (energyEffect.isPositive()){
        energyEffect.applyTo(battleCardGame.player);
      }
      else{
        energyEffect.applyTo(battleCardGame.rival);
      }

      battleCardGame.activatedEnergyCardId = cardEnergy.uniqueIdInGame;

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<SummonDigimonCardsToDigimonZone>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      if (battleCardGame.digimonsCanBeSummoned()) {
        battleCardGame.player.summonToDigimonZone();

        battleCardGame.rival.selectAllDigimonThatCanBeSummoned();
        battleCardGame.rival.summonToDigimonZone();

        battleCardGame.player.calculatePoints();
        battleCardGame.rival.calculatePoints();

        battleCardGame.toUpgradePhase();
        BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
        emit(state.copyWith(instance));
      }
    });

    on<ConfirmCompilationPhase>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.toSummonPhase();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<BattlePhaseInit>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.toBattlePhase();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<BattlePhasePlayerAttacksRival>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.player.attack(battleCardGame.rival); //Encapsular

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<BattlePhaseRivalAttacksPlayer>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      battleCardGame.rival.attack(battleCardGame.player);

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<BattlePhaseFinishRound>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
  
      battleCardGame.calculateWinner();
      battleCardGame.finishRound();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });
    
    on<ToDrawPhase>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
  
      battleCardGame.toDrawPhase();

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<ClearActivatedEquipmentCard>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
  
      battleCardGame.selectedEquipmentCardId = null;
      battleCardGame.targetDigimonId = null;

      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });

    on<ActivateSummonDigimonCard>((event, emit){
      BattleCardGame battleCardGame = state.battleCardGame;
      //IMPLEMENTAR LÓGICA
      BattleCardGame instance = BattleCardGame.fromInstance(battleCardGame);
      emit(state.copyWith(instance));
    });
  }
}
