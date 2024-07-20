import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/screens/overlay/internal/cards_deck_widget.dart';

class Deck extends World
  with HasGameRef, FlameBlocListenable<CardBattleBloc, CardBattleState> {
  late CardsDeckWidgetFactory playerCards;
  bool addedCardsToUi = false;

  Deck();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //final pauseOverlayIdentifier = 'Hand';
    print("LLEGO ON LOAD HAND");
    //game.overlays.add(pauseOverlayIdentifier);
    //game.overlays.remove(pauseOverlayIdentifier);
  }

  @override
  void onNewState(CardBattleState state) {
    if (!addedCardsToUi){
      playerCards = CardsDeckWidgetFactory(state.battleCardGame.player, false);
      addCards();
      addedCardsToUi = true;
    }
  }

  void addCards() {
    for (var cardComponent in playerCards.cardsComponent) {
      add(cardComponent);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
