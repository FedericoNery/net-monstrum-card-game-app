import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/domain/store/card_item.dart';
import 'package:net_monstrum_card_game/domain/store/list_card_adapter.dart';
import 'package:net_monstrum_card_game/graphql/mutations.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/infrastructure/graphql_client.dart';
import 'package:net_monstrum_card_game/state/coin_state.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';
import 'package:net_monstrum_card_game/widgets/shared/snackbar.dart';
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

  void buyCard(BuildContext context, RunMutation runMutation, CardItem card) {
    if (coins < card.price) {
      Navigator.of(context).pop();
      showWarning(context, 'No posee suficientes monedas');
      return;
    }

    if (card.ownedCount >= card.maxCopies) {
      Navigator.of(context).pop();
      showWarning(context, 'Alcanzó la máxima cantidad de copias de la carta');
      return;
    }

    lastCardIdPurchased = card.id;
    //userIdLocal = "670f2cd4798b3b58a3eb08e3";
    runMutation({"cardIdToPurchase": card.id, "userId": userIdLocal});
  }

  void showCardModal(CardItem card, VoidCallback? refetch, AppState appState,
      CoinState coinState) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: CardColor.toFlutterColor(card.color), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(card.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Image.asset(card.imageUrl.replaceAll(" ", "-"),
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/images/cards/card_back4.webp",
                        height: 100)),
              ),
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

                        bool cardNotFound =
                            resultData['purchaseCard']['cardNotFound'];
                        bool insuficientCoins =
                            resultData['purchaseCard']['insuficientCoins'];
                        bool reachedMaxCopiesOfCard = resultData['purchaseCard']
                            ['reachedMaxCopiesOfCard'];

                        if (cardNotFound) {
                          showError(context, 'Alguna carta no fué encontrada');
                          return;
                        }

                        if (insuficientCoins) {
                          showError(context, 'No posee suficientes monedas');
                          return;
                        }

                        if (reachedMaxCopiesOfCard) {
                          showError(
                              context, 'Alcanzó la cantidad máxima de cartas');
                          return;
                        }

                        if (successful) {
                          final index = cards.indexWhere(
                              (card) => card.id == lastCardIdPurchased);
                          if (index != -1) {
                            var ownedCountCalculated =
                                cards[index].ownedCount + 1;
                            cards[index] = cards[index]
                                .copyWith(ownedCount: ownedCountCalculated);
                            coins = coins - cards[index].price;
                            coinState.setCoins(coins);
                            //appState.setCoins(coins);

                            if (ownedCountCalculated == 4) {
                              cards.removeAt(index);
                            }
                          }

                          showSuccess(context, 'La compra fué exitosa');
                          refetch?.call();
                          Navigator.of(context).pop();
                        }
                      },
                      onError: (error) => print(error),
                    ),
                    builder: (RunMutation runMutation, QueryResult? result) {
                      return TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2, // Grosor del borde
                            ),
                          ),
                        )),
                        onPressed: () {
                          buyCard(context, runMutation, card);
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
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2, // Grosor del borde
                    ),
                  ),
                ))),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final coinState = Provider.of<CoinState>(context);
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
                    padding: const EdgeInsets.fromLTRB(8.0,8.0,32.0,8.0),
                    child: Center(child: Text('Monedas: $coins')),
                  )
                ]),
                body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 700 ? 4 : 3),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    if (card.isMaxOwned)
                      return Container(); // No mostrar si ya tiene 4

                    return InkWell(
                      onTap: () =>
                          showCardModal(card, refetch, appState, coinState),
                      child: Center(
                        child: SizedBox(
                          width: 120, // Limita el ancho del Card
                          child: Stack(
                            clipBehavior: Clip
                                .none, // Permite que el contador se superponga al borde
                            children: [
                              Card(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: CardColor.toFlutterColor(card.color),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Imagen de la carta ocupando todo el ancho
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Image.asset(
                                        card.imageUrl.replaceAll(" ", "-"),
                                        fit: BoxFit
                                            .contain, // Ajuste de la imagen al ancho
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/cards/card_back4.webp",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    // Nombre de la carta
                                    Text(
                                      card.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                              // Contador de copias en la esquina superior derecha
                              Positioned(
                                top: -10,
                                right: -10,
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
                      ),
                    );
                  },
                ),
              );
            }));
  }
}
