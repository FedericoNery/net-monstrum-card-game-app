import 'package:equatable/equatable.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class CardBattleState extends Equatable {
  late BattleCardGame battleCardGame;

  CardBattleState(this.battleCardGame);

  CardBattleState copyWith(BattleCardGame? battleCardGame) {
    return CardBattleState(battleCardGame ?? this.battleCardGame);
  }

  @override
  List<Object?> get props => [battleCardGame];
}
