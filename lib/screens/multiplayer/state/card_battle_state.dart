import 'package:equatable/equatable.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class CardBattleMultiplayerState extends Equatable {
  late BattleCardGame battleCardGame;

  CardBattleMultiplayerState(this.battleCardGame);

  CardBattleMultiplayerState copyWith(BattleCardGame? battleCardGame) {
    return CardBattleMultiplayerState(battleCardGame ?? this.battleCardGame);
  }

  @override
  List<Object?> get props => [battleCardGame];
}
