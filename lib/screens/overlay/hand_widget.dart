import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_event.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/factories/card_widget_factory.dart';

class Hand extends World
  with HasGameRef, FlameBlocListenable<CardBattleBloc, CardBattleState> {
  late CardWidgetFactory playerCards;
  bool addedCardsToUi = false;
  bool drawCardsEffectWasApplied = false;

  Hand();

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
    print("ON NEW STATE");
    print(state.battleCardGame.isDrawPhase());
    print(state.battleCardGame.decksShuffled);
    print(state.battleCardGame.drawedCards && !addedCardsToUi);
    if (state.battleCardGame.isDrawPhase() && state.battleCardGame.decksShuffled && state.battleCardGame.drawedCards && !addedCardsToUi){
      print("LLEGÓ");
      playerCards = CardWidgetFactory(state.battleCardGame.player, false);
      addCards();
      addedCardsToUi = true;
    }
  }

  void addCards() {
    add(playerCards.card1);
    add(playerCards.card2);
    add(playerCards.card3);
    add(playerCards.card4);
    add(playerCards.card5);
    add(playerCards.card6);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (bloc.state.battleCardGame.isDrawPhase() && bloc.state.battleCardGame.decksShuffled && !bloc.state.battleCardGame.drawedCards){
      bloc.add(DrawCards());
    }
    if (bloc.state.battleCardGame.isDrawPhase() && !bloc.state.battleCardGame.decksShuffled){
      bloc.add(ShuffleDeck());
    }
    if(bloc.state.battleCardGame.isDrawPhase() && bloc.state.battleCardGame.drawedCards && addedCardsToUi && !drawCardsEffectWasApplied){
      playerCards.applyDrawEffect();
      drawCardsEffectWasApplied = true;
      //bloc.add(ToCompilationPhase());
      //fadingText.addText("Compilation Phase");
    }
  }
}
