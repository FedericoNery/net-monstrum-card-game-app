import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/graphql/mutations.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:provider/provider.dart';

import '../domain/editor_deck/card_deck_editor.dart';
import '../domain/editor_deck/list_card_adapter.dart';
import '../widgets/deck_editor/avalaible_cards_area.dart';

class DeckEditorScreen extends StatefulWidget {
  late String folderId;

  DeckEditorScreen({required this.folderId});
  @override
  _DeckEditorScreenState createState() => _DeckEditorScreenState();
}

class _DeckEditorScreenState extends State<DeckEditorScreen> {
  List<CardDeckEditor> deck = [];
  String localUserId = "";

  void addCard(CardDeckEditor card) {
    setState(() {
      var listOfCardRepetitions =
          deck.where((element) => element.id == card.id);
      if (listOfCardRepetitions.length < 4) {
        deck.add(card);
      }
    });
  }

  void removeCard(CardDeckEditor card) {
    setState(() {
      var index = deck.indexWhere((card) => card.id == card.id);
      if (index != -1) {
        deck.removeAt(index);
      }
    });
  }

  void _onSaveDeck(RunMutation runMutation, String folderId) {
    List<String> cardsInput = deck.map((card) => card.id).toList();
    print(cardsInput);
    print(localUserId);
    print(folderId);
    runMutation({
      'userId': localUserId, //"670f2cd4798b3b58a3eb08e3", //
      'folderId': folderId,
      'cardIds': cardsInput,
    });
  }

  @override
  Widget build(BuildContext context) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();
    final appState = Provider.of<AppState>(context);
    String userId = appState.userInformation?["id"] ?? "";
    print("localUserId");
    print(localUserId);
    print("widget.folderId");
    print(widget.folderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editor de mazo'),
        actions: [
          GraphQLProvider(
              client: graphQlClientManager.client,
              child: Mutation(
                options: MutationOptions(
                  document: gql(updateFolder),
                  onCompleted: (dynamic resultData) {
                    bool cardNotExist =
                        resultData['purchaseCard']['cardNotExist'];
                    bool folderNotFound =
                        resultData['purchaseCard']['folderNotFound'];
                    bool reachedMaxCopiesOfCard =
                        resultData['purchaseCard']['reachedMaxCopiesOfCard'];
                    bool successful = resultData['purchaseCard']['successful'];

                    if (cardNotExist) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Error: Una o más cartas no se encontraron')),
                      );
                      return;
                    }

                    if (folderNotFound) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Error: No se encontró el mazo a actualizar')),
                      );
                      return;
                    }

                    if (reachedMaxCopiesOfCard) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Alcanzó la cantidad máxima de copias en una o más cartas')),
                      );
                      return;
                    }

                    if (successful) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('La edición del mazo fué exitosa')),
                      );
                    }
                  },
                  onError: (error) => print(error),
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () => _onSaveDeck(
                        runMutation, // "6670647552c07bc9e106083d"
                        widget.folderId),
                  );
                },
              )),
        ],
      ),
      body: Column(
        children: [
          // Sección superior horizontal
          GraphQLProvider(
              client: graphQlClientManager.client,
              child: Query(
                  options:
                      QueryOptions(document: gql(getFolderById), variables: {
                    "userId": userId, //"670f2cd4798b3b58a3eb08e3",
                    "folderId": widget.folderId //"6670647552c07bc9e106083d",
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
                      Map<String, dynamic> folderJson =
                          result.data?['getFolderById'];
                      List<Map<String, dynamic>> folderCardsJson =
                          (folderJson['cards'] as List?)?.map((card) {
                                return card as Map<String, dynamic>;
                              }).toList() ??
                              [];

                      List<CardDeckEditor> cardsOfDeck =
                          ListCardAdapterFromApi.getListOfCardsInstantiated(
                              folderCardsJson);

                      deck = cardsOfDeck;
                      localUserId = userId;
                    }
                    return SizedBox(
                      height: 200, // Altura fija
                      child: deck.isNotEmpty
                          ? GridView.builder(
                              padding: EdgeInsets.all(4.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                /* childAspectRatio: 2 / 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8, */
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: deck.length,
                              itemBuilder: (context, index) {
                                final card = deck[index];
                                return GestureDetector(
                                    onTap: () => removeCard(card),
                                    child: CardWidget(
                                        card: card,
                                        widthContainer: 70,
                                        heightImage: 45,
                                        fontSize: 8));
                              },
                            )
                          : Center(child: Text('No cards selected')),
                    );
                  })),
          Divider(),
          // Sección inferior con ListView en forma de grilla

          GraphQLProvider(
              client: graphQlClientManager.client,
              child: Query(
                  options:
                      QueryOptions(document: gql(getAllCards), variables: {}),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<Map<String, dynamic>> availableCardsJson =
                        (result.data?['cards'] as List?)?.map((card) {
                              return card as Map<String, dynamic>;
                            }).toList() ??
                            [];

                    List<CardDeckEditor> availableCardsTransformed =
                        ListCardAdapterFromApi.getListOfCardsInstantiated(
                            availableCardsJson);

                    return Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                        itemCount: availableCardsTransformed.length,
                        itemBuilder: (context, index) {
                          final card = availableCardsTransformed[index];
                          return GestureDetector(
                              onTap: () => addCard(card),
                              child: CardWidget(
                                  card: card, heightImage: 100, fontSize: 16));
                        },
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
