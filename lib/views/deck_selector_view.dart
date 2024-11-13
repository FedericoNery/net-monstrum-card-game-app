import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/app_state.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';
import 'package:net_monstrum_card_game/views/menu.dart';
import 'package:net_monstrum_card_game/widgets/deck_selector/deck_list.dart';
import 'package:provider/provider.dart';

import 'multiplayer_game_view.dart';

class DeckSelectionScreen extends StatelessWidget {
  int redirectionOption = 0;
  Function onNavigation;

  DeckSelectionScreen(
      {super.key, required this.redirectionOption, required this.onNavigation});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    String title = redirectionOption == REDIRECT_OPTIONS.TO_EDIT_DECK
        ? "Seleccionar Mazo a editar"
        : "Seleccionar Mazo para jugar";

    bool skipSelectorDeckScreen =
        dotenv.env['SKIP_SELECTOR_DECK_SCREEN']?.toLowerCase() == 'true';

    /* if (skipSelectorDeckScreen) {
      return MultiplayerGameView();
    } */

    final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Query(
          options: QueryOptions(
              fetchPolicy: FetchPolicy.networkOnly,
              document: gql(getUserByIdQuery),
              variables: {"id": appState.userInformation?["id"]}),
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
              child: DeckList(decks, redirectionOption, onNavigation, refetch),
            );
          },
        ),
      ),
    );
  }
}
