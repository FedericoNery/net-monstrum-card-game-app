import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/views/deck_editor_example1.dart';

class CardDeckEditor extends StatelessWidget {
  const CardDeckEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Deck Editor',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editor de Mazo de Cartas'),
        ),
        body: DeckEditorScreen(), //const PlaySessionScreen(),
      ),
    );
  }
}
