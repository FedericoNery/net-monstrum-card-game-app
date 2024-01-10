import 'package:net_monstrum_card_game/services/cardsService.dart';
import 'package:net_monstrum_card_game/services/decksServices.dart';
import 'package:net_monstrum_card_game/services/usersService.dart';

import '../domain/Card.dart';
import '../domain/card-digimon.dart';
import '../domain/deck.dart';
import '../domain/user.dart';

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
  DeckService DecksService = new DeckService();
  UsersService usersService = new UsersService();

  Aggregation getAggregatioByUserId(int id) {
    User? user = this.usersService.getUserById(id);
    List<DeckAggregation> decksAggregations = [];

    List<Deck> decksEntities= [];
    for (final deckId in user!.decksIds) {
      Deck deck = DeckService().getDeckById(deckId);
      decksEntities.add(deck);
    }

    for (final deck in decksEntities){
      List<Card> cards = [];
      for (final idCard in deck.cardsIds){
        Card card = this.cardsService.getCardById(idCard);
        cards.add(card);
      }

      DeckAggregation deckAggregation = new DeckAggregation(deck.id, cards);
      decksAggregations.add(deckAggregation);
    }

    Aggregation aggregation = new Aggregation(user, decksAggregations);
    return aggregation;
  }
}