class Deck {
  List<Card> cards;

  Deck(this.cards);

  List<Card> drawCards(int count) {
    if (count > cards.length) {
      throw Exception("No hay suficientes cartas en el mazo");
    }

    List<Card> drawnCards = cards.sublist(0, count);
    cards.removeRange(0, count);
    return drawnCards;
  }
}

class Basura {
  List<Card> cards;

  Basura(this.cards);

  void addToBasura(int index) {
    cards.add(cards.removeAt(index));
  }

  void removeFromBasura(int index) {
    cards.removeAt(index);
  }
}

class Hand {
  List<Card> cards;

  Hand(this.cards);

  void addToHand(Card card) {
    cards.add(card);
  }

  void removeFromHand(int index) {
    cards.removeAt(index);
  }
}

class DigimonZone {
  List<Card> cards;

  DigimonZone(this.cards);

  void addToDigimonZone(Card card) {
    cards.add(card);
  }

  void removeFromDigimonZone(int index) {
    cards.removeAt(index);
  }
}

class Tamer {
  Deck deck;
  Basura basura;
  Hand hand;
  DigimonZone digimonZone;

  Tamer(this.deck, this.basura, this.hand, this.digimonZone);
}

class Game {
  Tamer tamer1;
  Tamer tamer2;

  Game(this.tamer1, this.tamer2);
}