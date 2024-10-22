import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/widgets/deck_selector/deck_item.dart';

class DeckList extends StatelessWidget {
  late List<Map<String, dynamic>> decks;
  late int redirectOption;
  DeckList(this.decks, this.redirectOption, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: decks
          .map((deck) => DeckItem(
              deckId: deck['id'],
              redirectOption: redirectOption,
              deckName: deck['name'],
              deckColors: deck['colors'],
              cards: _groupCards((deck['cards'] as List)
                  .map((card) => card as Map<String, dynamic>)
                  .toList()),
              originalDeckCards: (deck['cards'] as List)
                  .map((card) => card as Map<String, dynamic>)
                  .toList()))
          .toList(),
    );
  }

  // Agrupar cartas por su nombre
  Map<String, Map<String, dynamic>> _groupCards(
      List<Map<String, dynamic>> cards) {
    Map<String, Map<String, dynamic>> cardCounts = {};
    for (var card in cards) {
      if (card['__typename'] == 'CardDigimon' ||
          card['__typename'] == 'CardEnergy') {
        String name = card['name'];
        String color = card['color'].toString().toLowerCase();
        if (cardCounts.containsKey(name)) {
          cardCounts[name]!['count'] += 1;
        } else {
          cardCounts[name] = {'count': 1, 'color': color};
        }
      }
    }
    return cardCounts;
  }
}
