class Deck {
  int id;
  List<int> cardsIds;

  Deck(this.id, this.cardsIds);
}

class DeckService {
  List<Deck> _deckList = [];

  DeckService() {
    for (int i = 1; i <= 3; i++) {
      List<int> cardIds = List.generate(40, (index) => index + 1);
      _deckList.add(Deck(i, cardIds));
    }
  }

  Deck getDeckById(int id) {
    return _deckList.firstWhere((deck) => deck.id == id, orElse: () => null);
  }
}