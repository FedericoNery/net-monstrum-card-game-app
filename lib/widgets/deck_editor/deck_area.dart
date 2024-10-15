import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';

class DeckArea extends StatelessWidget {
  final List<CardDeckEditor> deck;
  final Function(String) onRemoveCard;

  DeckArea({required this.deck, required this.onRemoveCard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Mazo'),
        Expanded(
          child: ListView.builder(
            itemCount: deck.length,
            itemBuilder: (context, index) {
              final card = deck[index];
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CardColor.toFlutterColor(card.color),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset(card.imageName, height: 100),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(card.name),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => onRemoveCard(card.id),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
