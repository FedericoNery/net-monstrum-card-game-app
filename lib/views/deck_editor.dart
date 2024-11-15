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
  VoidCallback? refetchPreviewDecks;
  DeckEditorScreen({required this.folderId, required this.refetchPreviewDecks});
  @override
  _DeckEditorScreenState createState() => _DeckEditorScreenState();
}

class _DeckEditorScreenState extends State<DeckEditorScreen> {
  List<CardDeckEditor> deck = [];
  String localUserId = "";

  void addCard(CardDeckEditor card, BuildContext context) {
    setState(() {
      var listOfCardRepetitions =
          deck.where((element) => element.id == card.id);
      if (listOfCardRepetitions.length < 4 &&
          listOfCardRepetitions.length < card.quantityLimit!) {
        deck.add(card);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Alcanzó el límite de copias de la carta seleccionada')),
        );
      }
    });
  }

  void removeCard(CardDeckEditor card) {
    setState(() {
      var index = deck.indexWhere((cardFromDeck) => cardFromDeck.id == card.id);
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
/*     print("localUserId");
    print(localUserId);
    print("widget.folderId");
    print(widget.folderId); */

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
                        resultData['updateFolder']['cardNotExist'];
                    bool folderNotFound =
                        resultData['updateFolder']['folderNotFound'];
                    bool reachedMaxCopiesOfCard =
                        resultData['updateFolder']['reachedMaxCopiesOfCard'];
                    bool successful = resultData['updateFolder']['successful'];

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
                      widget.refetchPreviewDecks?.call();
                    }
                  },
                  onError: (OperationException? error) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  ),
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
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
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
                                        heightImage: 60,
                                        fontSize: 8));
                              },
                            )
                          : const Center(child: Text('No hay cartas')),
                    );
                  })),
          Divider(),
          // Sección inferior con ListView en forma de grilla

          GraphQLProvider(
              client: graphQlClientManager.client,
              child: Query(
                  options: QueryOptions(
                      document: gql(getAvailableCardsToPutInDeck),
                      variables: {"userId": userId}),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<Map<String, dynamic>> availableCardsJson =
                        (result.data?['getAvailableCardsToPutInDeck'] as List?)
                                ?.map((card) {
                              return card as Map<String, dynamic>;
                            }).toList() ??
                            [];

                    List<CardDeckEditor> availableCardsTransformed =
                        ListCardAdapterFromApi
                            .getListAvailableCardsInstantiated(
                                availableCardsJson);

                    return Expanded(
                      child: GridView.builder(
                        padding: null,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 700 ? 5 : 4,
                            childAspectRatio: 1),
                        itemCount: availableCardsTransformed.length,
                        itemBuilder: (context, index) {
                          final card = availableCardsTransformed[index];
                          return GestureDetector(
                              onTap: () => addCard(card, context),
                              child: CardWidget(
                                card: card,
                                heightImage: 80,
                                fontSize: 16,
                                widthContainer: 100,
                              ));
                        },
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
