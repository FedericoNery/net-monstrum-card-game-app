import 'package:equatable/equatable.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';

abstract class CardBattleEvent extends Equatable {
  const CardBattleEvent();
}

/* class WeaponEquipped extends InventoryEvent {
  final Weapon weapon;

  const WeaponEquipped(this.weapon);

  @override
  List<Object?> get props => [weapon];
} */

class NextWeaponEquipped extends CardBattleEvent {
  const NextWeaponEquipped();

  @override
  List<Object?> get props => [];
}

class DrawCards extends CardBattleEvent {
  const DrawCards();

  @override
  List<Object?> get props => [];
}

class SelectDigimonCardFromHandToSummon extends CardBattleEvent {
  final int cardId;
  const SelectDigimonCardFromHandToSummon(this.cardId);

  @override
  List<Object?> get props => [];
}

class SelectDigimonCardToBeEquipped extends CardBattleEvent {
  final int cardId;
  const SelectDigimonCardToBeEquipped(this.cardId);

  @override
  List<Object?> get props => [];
}


class SelectEquipmentCardFromHandTo extends CardBattleEvent {
  final CardEquipment cardEquipment;
  const SelectEquipmentCardFromHandTo(this.cardEquipment);

  @override
  List<Object?> get props => [];
}

class ActivateEnergyCard extends CardBattleEvent {
  final CardEnergy cardEnergy;
  const ActivateEnergyCard(this.cardEnergy);

  @override
  List<Object?> get props => [];

}

class SummonDigimonCardsToDigimonZone extends CardBattleEvent {
  const SummonDigimonCardsToDigimonZone();

  @override
  List<Object?> get props => [];

}

class ShuffleDeck extends CardBattleEvent {
  const ShuffleDeck();

  @override
  List<Object?> get props => [];
}

class ConfirmCompilationPhase extends CardBattleEvent {
  const ConfirmCompilationPhase();

  @override
  List<Object?> get props => [];
}

class BattlePhaseInit extends CardBattleEvent {
  const BattlePhaseInit();

  @override
  List<Object?> get props => [];
}

class BattlePhaseFinishRound extends CardBattleEvent {
  const BattlePhaseFinishRound();

  @override
  List<Object?> get props => [];
}

class ToDrawPhase extends CardBattleEvent {
  const ToDrawPhase();

  @override
  List<Object?> get props => [];
}

class ClearActivatedEquipmentCard extends CardBattleEvent {
  const ClearActivatedEquipmentCard();

  @override
  List<Object?> get props => [];
}

class BattlePhasePlayerAttacksRival extends CardBattleEvent {
  const BattlePhasePlayerAttacksRival();

  @override
  List<Object?> get props => [];
}

class BattlePhaseRivalAttacksPlayer extends CardBattleEvent {
  const BattlePhaseRivalAttacksPlayer();

  @override
  List<Object?> get props => [];
}