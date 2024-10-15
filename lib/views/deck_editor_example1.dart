import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/graphql/mutations.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';

import '../domain/editor_deck/card_deck_editor.dart';
import '../domain/editor_deck/list_card_adapter.dart';
import '../widgets/deck_editor/avalaible_cards_area.dart';
import '../widgets/deck_editor/deck_area.dart';
import '../widgets/deck_editor/drop_area.dart';

class DeckEditorScreen extends StatefulWidget {
  @override
  _DeckEditorScreenState createState() => _DeckEditorScreenState();
}

class _DeckEditorScreenState extends State<DeckEditorScreen> {
  List<CardDeckEditor> deck = [];

  void _removeCardFromDeck(String cardId) {
    setState(() {
      var index = deck.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        deck.removeAt(index);
      }
    });
  }

  void _addCardToDeck(CardDeckEditor card) {
    setState(() {
      var listOfCardRepetitions =
          deck.where((element) => element.id == card.id);
      if (listOfCardRepetitions.length < 4) {
        deck.add(card);
      }
    });
  }

  void _onSaveDeck(RunMutation runMutation) {
    List<String> cardsInput = deck.map((card) => card.id).toList();
    runMutation({
      'userId': "670b45598d56cdba07bd0876",
      'folderId': "6670647552c07bc9e106083d",
      'cardIds': cardsInput,
    });
  }

  @override
  Widget build(BuildContext context) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();
    return GraphQLProvider(
        client: graphQlClientManager.client,
        child: Query(
            options:
                QueryOptions(document: gql(getFolderById), variables: const {
              "userId": "670b45598d56cdba07bd0876",
              "folderId": "6670647552c07bc9e106083d",
            }),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (deck.isEmpty) {
                Map<String, dynamic> folderJson = result.data?['getFolderById'];
                String id = folderJson["id"];
                String name = folderJson["name"];

                List<Map<String, dynamic>> folderCardsJson =
                    (folderJson['cards'] as List?)?.map((card) {
                          return card as Map<String, dynamic>;
                        }).toList() ??
                        [];

                List<CardDeckEditor> cardsOfDeck =
                    ListCardAdapterFromApi.getListOfCardsInstantiated(
                        folderCardsJson);

                deck = cardsOfDeck;
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text('Deck Editor'),
                  actions: [
                    // Botón de guardar en el AppBar
                    Mutation(
                      options: MutationOptions(
                        document: gql(updateFolder),
                        onCompleted: (dynamic resultData) {
                          // Controlar los mensajes que están en la mutation
                          print(resultData);
                        },
                        onError: (error) => print(error),
                      ),
                      builder: (RunMutation runMutation, QueryResult? result) {
                        return IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () => _onSaveDeck(runMutation),
                        );
                      },
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    Expanded(
                        child: DeckArea(
                            deck: deck, onRemoveCard: _removeCardFromDeck)),
                    VerticalDivider(),
                    Expanded(child: AvailableCardsArea()),
                    VerticalDivider(),
                    Expanded(child: DropArea(onCardDropped: _addCardToDeck)),
                  ],
                ),
              );
            }));
  }
}
