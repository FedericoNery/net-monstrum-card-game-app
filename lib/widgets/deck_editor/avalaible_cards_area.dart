import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/list_card_adapter.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';

import '../../infrastructure/graphql_client.dart';

class AvailableCardsArea extends StatelessWidget {
  final Function(CardDeckEditor) onCardPressed;

  AvailableCardsArea({required this.onCardPressed});

  @override
  Widget build(BuildContext context) {
    GraphQlClientManager graphQlClientManager = GraphQlClientManager();

    return GraphQLProvider(
      client: graphQlClientManager.client,
      child: Query(
        options: QueryOptions(document: gql(getAllCards), variables: {}),
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

          return Column(
            children: [
              Text('Cartas Disponibles'),
              Expanded(
                child: ListView.builder(
                  itemCount: availableCardsTransformed.length,
                  itemBuilder: (context, index) {
                    final card = availableCardsTransformed[index];
                    return GestureDetector(
                      onTap: () => onCardPressed(card), // Llamada a la función
                      child: Draggable<CardDeckEditor>(
                        data: card,
                        child: CardWidget(card: card),
                        feedback: CardWidget(card: card),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: CardWidget(card: card),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardDeckEditor card;
  double? heightImage = 100;
  double? fontSize = 8;
  double? widthContainer = 120;

  CardWidget(
      {required this.card,
      this.heightImage,
      this.fontSize,
      this.widthContainer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widthContainer, // Limita el ancho del Card
        child: Stack(
          clipBehavior:
              Clip.none, // Permite que el contador se superponga al borde
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
                    height: heightImage,
                    child: Image.asset(
                      card.imageName,
                      fit: BoxFit.contain, // Ajuste de la imagen al ancho
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/images/cards/card_back4.webp",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Nombre de la carta
                  Text(
                    card.name,
                    style: TextStyle(
                        fontSize: fontSize, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: CardColor.toFlutterColor(card.color), // sin el operador `?.`
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            card.imageName,
            height: heightImage,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset("assets/images/cards/card_back4.webp", height: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(card.name,
                style: TextStyle(
                    fontSize: fontSize, // Otro tamaño para este texto
                    overflow: TextOverflow.ellipsis)),
          ),
        ],
      ),
    );
  }
}
