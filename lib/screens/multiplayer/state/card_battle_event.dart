import 'package:equatable/equatable.dart';
import 'package:net_monstrum_card_game/adapters/battle_card_game_adapter.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

abstract class CardBattleMultiplayerEvent extends Equatable {
  const CardBattleMultiplayerEvent();
}

class UpdateHandAndDeckAfterDrawedPhase extends CardBattleMultiplayerEvent {
  final BattleCardGameFromJSON bcgFromJson;

  const UpdateHandAndDeckAfterDrawedPhase(
    this.bcgFromJson,
  );

  @override
  List<Object?> get props => [];
}

class DrawCards extends CardBattleMultiplayerEvent {
  const DrawCards();

  @override
  List<Object?> get props => [];
}

class ToCompilationPhase extends CardBattleMultiplayerEvent {
  const ToCompilationPhase();

  @override
  List<Object?> get props => [];
}

class SelectDigimonCardFromHandToSummon extends CardBattleMultiplayerEvent {
  final int cardId;
  const SelectDigimonCardFromHandToSummon(this.cardId);

  @override
  List<Object?> get props => [];
}

class SelectEquipmentCardFromHand extends CardBattleMultiplayerEvent {
  final int cardId;
  const SelectEquipmentCardFromHand(this.cardId);

  @override
  List<Object?> get props => [];
}

class RefuseEquipmentCardFromHand extends CardBattleMultiplayerEvent {
  final int cardId;
  const RefuseEquipmentCardFromHand(this.cardId);

  @override
  List<Object?> get props => [];
}

class ResetLocalState extends CardBattleMultiplayerEvent {
  final BattleCardGameFromJSON bcgFromJson;

  const ResetLocalState(this.bcgFromJson);

  @override
  List<Object?> get props => [];
}

class LogAction extends CardBattleMultiplayerEvent {
  final String text;

  const LogAction(this.text);

  @override
  List<Object?> get props => [];
}

/* class SelectDigimonCardToBeEquipped extends CardBattleMultiplayerEvent {
  final int cardDigimonId;
  const SelectDigimonCardToBeEquipped(this.cardDigimonId);

  @override
  List<Object?> get props => [];
}
 */