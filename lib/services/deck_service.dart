import '../domain/data/deck.dart';

class DeckService {
  List<Deck> _deckList = [];

  DeckService() {
    List<int> cardIdsDeck1 = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 5, 5, 5, 5, 77, 77, 77, 77, 78, 78, 78, 78, 86, 87, 88, 86, 87, 88, 92, 93, 94, 92, 93, 94];
    _deckList.add(Deck(1, cardIdsDeck1));

    List<int> cardIdsDeck2 = [65, 66, 67, 68, 65, 66, 67, 68, 65, 66, 67, 68, 65, 66, 67, 68, 49, 49, 49, 49, 9, 9, 9, 9, 77, 77, 77, 77, 78, 78, 78, 78, 86, 87, 88, 86, 87, 88, 92, 93, 94, 92, 93, 94];
    _deckList.add(Deck(2, cardIdsDeck2));

    List<int> cardIdsDeck3 = [13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 5, 5, 5, 5, 9, 9, 9, 9, 77, 77, 77, 77, 78, 78, 78, 78, 86, 87, 88, 86, 87, 88, 92, 93, 94, 92, 93, 94];
    _deckList.add(Deck(3, cardIdsDeck3));
  }

  Deck getDeckById(int id) {
    return _deckList.firstWhere((deck) => deck.id == id);
  }

}