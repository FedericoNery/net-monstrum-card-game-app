import 'package:net_monstrum_card_game/services/cards_service.dart';
import 'package:net_monstrum_card_game/services/deck_service.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';

import '../domain/card/card_base.dart';
import '../domain/data/deck.dart';
import '../domain/data/user.dart';

class DeckAggregation {
  int id;
  List<Card> cards;

  DeckAggregation(this.id, this.cards);
}

class Aggregation{
  User user;
  List<DeckAggregation> decksAggregations;

  Aggregation(this.user, this.decksAggregations);
}

class AggregationService {
  CardsService cardsService = new CardsService();
  DeckService decksService = new DeckService();
  UsersService usersService = new UsersService();

  Aggregation getAggregatioByUserId(int id) {
    User? user = this.usersService.getUserById(id);
    List<DeckAggregation> decksAggregations = [];

    List<Deck> decksEntities= [];
    for (final deckId in user!.decksIds) {
      Deck deck = decksService.getDeckById(deckId);
      decksEntities.add(deck);
    }

    for (final deck in decksEntities){
      List<Card> cards = [];
      int counter = 0;
      for (final idCard in deck.cardsIds){
        Card card = this.cardsService.getCardById(idCard);
        card.internalGameId = counter;
        cards.add(card);
        counter++;
      }

      DeckAggregation deckAggregation = new DeckAggregation(deck.id, cards);
      decksAggregations.add(deckAggregation);
    }

    Aggregation aggregation = new Aggregation(user, decksAggregations);
    return aggregation;
  }
}