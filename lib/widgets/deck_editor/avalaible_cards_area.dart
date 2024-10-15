import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/list_card_adapter.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';

import '../../infrastructure/graphql_client.dart';

class AvailableCardsArea extends StatelessWidget {
  AvailableCardsArea();

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
            List<Map<String, dynamic>> avalaibleCardsJson =
                (result.data?['cards'] as List?)?.map((card) {
                      return card as Map<String, dynamic>;
                    }).toList() ??
                    [];

            List<CardDeckEditor> availableCardsTransformed =
                ListCardAdapterFromApi.getListOfCardsInstantiated(
                    avalaibleCardsJson);

            return Column(
              children: [
                Text('Cartas Disponibles'),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableCardsTransformed.length,
                    itemBuilder: (context, index) {
                      final card = availableCardsTransformed[index];
                      return Draggable<CardDeckEditor>(
                        data: card,
                        child: CardWidget(card: card),
                        feedback: CardWidget(card: card),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: CardWidget(card: card),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}

class CardWidget extends StatelessWidget {
  final CardDeckEditor card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: CardColor.toFlutterColor(card?.color), width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            card.imageName,
            height: 100,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset("assets/images/cards/card_back4.webp", height: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(card.name),
          ),
        ],
      ),
    );
  }
}
