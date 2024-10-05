import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/main.dart';
import 'package:provider/provider.dart';

import 'multiplayer_game_view.dart';

class DeckSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool skipSelectorDeckScreen =
        dotenv.env['SKIP_SELECTOR_DECK_SCREEN']?.toLowerCase() == 'true';

    if (skipSelectorDeckScreen) {
      return MultiplayerGameView();
    }

    final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'Seleccionar Mazo',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Seleccionar Mazo'),
            ),
            body: Query(
              options: QueryOptions(
                  document: gql(getUserByIdQuery),
                  variables: const {"id": "66901450cbb6e1156be57426"}),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> decks =
                    (result.data?['getUserById']['folders'] as List?)
                            ?.map((folder) {
                          return folder as Map<String, dynamic>;
                        }).toList() ??
                        [];

                return Center(
                  child: DeckList(decks),
                );
              },
            ),
          ),
        ));
  }
}

class DeckList extends StatelessWidget {
  late List<Map<String, dynamic>> decks;

  DeckList(this.decks, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: decks
          .map((deck) => DeckItem(
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

class DeckItem extends StatefulWidget {
  final String deckName;
  final Map<String, dynamic> deckColors;
  final Map<String, Map<String, dynamic>> cards;
  final List<Map<String, dynamic>> originalDeckCards;

  DeckItem(
      {required this.deckName,
      required this.deckColors,
      required this.cards,
      required this.originalDeckCards});

  @override
  _DeckItemState createState() => _DeckItemState();
}

class _DeckItemState extends State<DeckItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                      color: _getColor(entry.key),
                    ),
                    SizedBox(width: 5),
                    Text('${entry.value}', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 10),
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
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Cantidad de columnas
                childAspectRatio: 3, // Relación de aspecto para cada carta
              ),
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                String cardName = widget.cards.keys.elementAt(index);
                int cardCount = widget.cards[cardName]!['count'];
                String cardColor = widget.cards[cardName]!['color'];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(
                        '$cardCount x $cardName',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 20,
                        height: 20,
                        color: _getColor(cardColor),
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
                  _onDeckSelected(context, widget.originalDeckCards);
                },
                child: Text('Seleccionar ${widget.deckName}'),
              ),
            ),
        ],
      ),
    );
  }

  // Devuelve el color en función del nombre
  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  void _onDeckSelected(BuildContext context, List<Map<String, dynamic>> cards) {
    final appState = Provider.of<AppState>(context);
    appState.setSelectedDeck(cards);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiplayerGameView(),
      ),
    );
  }
}

/* class DeckDetailsScreen extends StatelessWidget {
  final String deckName;

  DeckDetailsScreen({required this.deckName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de $deckName'),
      ),
      body: Center(
        child: Text('Has seleccionado $deckName'),
      ),
    );
  }
} */
