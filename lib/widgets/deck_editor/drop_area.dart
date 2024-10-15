import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';

class DropArea extends StatelessWidget {
  final Function(CardDeckEditor) onCardDropped;

  DropArea({required this.onCardDropped});

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardDeckEditor>(
      onAccept: (card) => onCardDropped(card),
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: [
            Text('Arrastra aquí para agregar al mazo'),
            Expanded(
              child: Container(
                color: candidateData.isNotEmpty
                    ? Colors.green.withOpacity(0.2)
                    : Colors.transparent,
                child: Center(
                  child: candidateData.isNotEmpty
                      ? Text('Suelta para agregar')
                      : Text('Zona de Drop'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
