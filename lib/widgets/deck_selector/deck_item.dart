import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/views/deck_editor.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:net_monstrum_card_game/views/multiplayer_game_view.dart';
import 'package:net_monstrum_card_game/widgets/deck_selector/colors.dart';
import 'package:provider/provider.dart';

class DeckItem extends StatefulWidget {
  final String deckId;
  final String deckName;
  final Map<String, dynamic> deckColors;
  final Map<String, Map<String, dynamic>> cards;
  final List<Map<String, dynamic>> originalDeckCards;
  final int redirectOption;
  Function onNavigation = () {};
  VoidCallback? refetchPreviewDecks;
  DeckItem(
      {required this.deckId,
      required this.redirectOption,
      required this.deckName,
      required this.deckColors,
      required this.cards,
      required this.originalDeckCards,
      required this.onNavigation,
      required this.refetchPreviewDecks});

  @override
  _DeckItemState createState() => _DeckItemState();
}

class _DeckItemState extends State<DeckItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.deckName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.deckColors.entries.map((entry) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: getColor(entry.key),
                    ),
                    const SizedBox(width: 5),
                    Text('${entry.value}',
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Cantidad de columnas
                childAspectRatio: 8, // Relación de aspecto para cada carta
              ),
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                String cardName = widget.cards.keys.elementAt(index);
                int cardCount = widget.cards[cardName]!['count'];
                String cardColor = widget.cards[cardName]!['color'];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Wrap(
                    children: [
                      Text(
                        '$cardCount x $cardName',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 20,
                        height: 20,
                        color: getColor(cardColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  var transformedDeck =
                      withUniqueIdCards(widget.originalDeckCards);
                  appState.setSelectedDeck(transformedDeck);

                  _onDeckSelected(
                      context,
                      widget.originalDeckCards,
                      widget.redirectOption,
                      widget.deckId,
                      widget.onNavigation,
                      widget.refetchPreviewDecks);
                },
                child: Text('Seleccionar ${widget.deckName}'),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> withUniqueIdCards(
      List<Map<String, dynamic>> originalDeck) {
    List<Map<String, dynamic>> transformedDeck = [];
    int counter = 1;
    for (var i = 0; i < originalDeck.length; i++) {
      var card = originalDeck[i];
      card["uniqueIdInGame"] = counter;
      transformedDeck.add(card);
      counter++;
    }
    return transformedDeck;
  }

  void _onDeckSelected(
      BuildContext context,
      List<Map<String, dynamic>> cards,
      int redirectOption,
      String folderId,
      Function onNavigation,
      VoidCallback? refetchPreviewDecks) {
    if (redirectOption == REDIRECT_OPTIONS.TO_MULTIPLAYER) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerGameView(onNavigation),
        ),
      );
    }

    if (redirectOption == REDIRECT_OPTIONS.TO_EDIT_DECK) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeckEditorScreen(
              folderId: folderId, refetchPreviewDecks: refetchPreviewDecks),
        ),
      );
    }
  }
}
