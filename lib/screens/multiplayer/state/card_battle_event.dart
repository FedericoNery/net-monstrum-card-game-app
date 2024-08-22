import 'package:equatable/equatable.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';

abstract class CardBattleMultiplayerEvent extends Equatable {
  const CardBattleMultiplayerEvent();
}

class UpdateHandAndDeckAfterDrawedPhase extends CardBattleMultiplayerEvent {
  final List<Card> deckPlayer;
  final List<Card> handPlayer;
  final List<Card> deckRival;
  final List<Card> handRival;
  final EnergiesCounters energiesPlayer;
  final EnergiesCounters energiesRival;

  const UpdateHandAndDeckAfterDrawedPhase(this.deckPlayer, this.handPlayer,
      this.deckRival, this.handRival, this.energiesPlayer, this.energiesRival);

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
