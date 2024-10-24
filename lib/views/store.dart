import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/domain/store/card_item.dart';
import 'package:net_monstrum_card_game/domain/store/list_card_adapter.dart';
import 'package:net_monstrum_card_game/graphql/mutations.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';
import 'package:provider/provider.dart';

class CardShop extends StatefulWidget {
  @override
  _CardShopState createState() => _CardShopState();
}

class _CardShopState extends State<CardShop> {
  int coins = 0;
  bool wasFetched = false;
  List<CardItem> cards = [];
  String lastCardIdPurchased = "";
  String userIdLocal = "";

  void buyCard(RunMutation runMutation, CardItem card) {
    if (coins >= card.price && card.ownedCount < card.maxCopies) {
      /* setState(() {
        card.ownedCount++;
        coins -= card.price;
      }); */
      lastCardIdPurchased = card.id;
      //userIdLocal = "670f2cd4798b3b58a3eb08e3";
      runMutation({"cardIdToPurchase": card.id, "userId": userIdLocal});
    }
  }

  void showCardModal(CardItem card, VoidCallback? refetch) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(card.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(card.imageUrl,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/cards/card_back4.webp",
                      height: 100)), // Imagen de la carta
              SizedBox(height: 10),
              Text('Precio: ${card.price} monedas'),
              Text('Propias: ${card.ownedCount}/${card.maxCopies}'),
            ],
          ),
          actions: [
            if (card.ownedCount < card.maxCopies)
              GraphQLProvider(
                  client: graphQlClientManager.client,
                  child: Mutation(
                    options: MutationOptions(
                      document: gql(purchaseCard),
                      onCompleted: (dynamic resultData) {
                        // Controlar los mensajes que están en la mutation
                        bool successful =
                            resultData['purchaseCard']['successful'];
                        if (successful) {
                          final index = cards.indexWhere(
                              (card) => card.id == lastCardIdPurchased);
                          if (index != -1) {
                            var ownedCountCalculated =
                                cards[index].ownedCount + 1;
                            cards[index] = cards[index]
                                .copyWith(ownedCount: ownedCountCalculated);
                            coins = coins - cards[index].price;
                            if (ownedCountCalculated == 4) {
                              cards.removeAt(index);
                            }
                          }
                          refetch?.call();
                          Navigator.of(context).pop();
                        }
                      },
                      onError: (error) => print(error),
                    ),
                    builder: (RunMutation runMutation, QueryResult? result) {
                      return TextButton(
                        onPressed: () {
                          buyCard(runMutation, card);
                        },
                        child: Text('Comprar'),
                      );
                    },
                  )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    String userId = appState.userInformation?["id"];
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();

    return GraphQLProvider(
        client: graphQlClientManager.client,
        child: Query(
            options:
                QueryOptions(document: gql(getStoreCardsByUserId), variables: {
              "userId": userId,
            }),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!wasFetched) {
                List<dynamic> cardsJson = result
                    .data?['getAvailableCardsToPurchase'] as List<dynamic>;

                List<Map<String, dynamic>> cardsMapped =
                    cardsJson.map((purchasedCard) {
                          return {
                            "card":
                                purchasedCard["card"] as Map<String, dynamic>,
                            "quantity": purchasedCard["quantity"] as int
                          };
                        }).toList() ??
                        [];
                List<CardItem> cardsOfStore =
                    ListCardAdapterFromApi.getListOfCardsInstantiated(
                        cardsMapped);
                cards = cardsOfStore;
                wasFetched = true;
                coins = appState.userInformation?["coins"];
                userIdLocal = userId;
              }
              return Scaffold(
                appBar: AppBar(title: Text('Comprar Cartas'), actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Monedas: $coins')),
                  )
                ]),
                body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3), // Cambiado a 3 cartas por fila
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    if (card.isMaxOwned)
                      return Container(); // No mostrar si ya tiene 4

                    return GestureDetector(
                      onTap: () => showCardModal(card, refetch),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: CardColor.toFlutterColor(card.color),
                              width: 2), // Borde de la carta
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(card.imageUrl,
                                    height: 100,
                                    width: 100,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            "assets/images/cards/card_back4.webp",
                                            height: 100)), // Imagen de la carta
                                Text(card.name, style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            if (card.isNew)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.green,
                                  child: Text('Nueva',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${card.ownedCount}/${card.maxCopies}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }));
  }
}
