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

class DeckSelectionScreen extends StatefulWidget {
  final int redirectionOption;
  final Function onNavigation;

  const DeckSelectionScreen({
    super.key,
    required this.redirectionOption,
    required this.onNavigation,
  });

  @override
  State<DeckSelectionScreen> createState() => _DeckSelectionScreenState();
}

class _DeckSelectionScreenState extends State<DeckSelectionScreen> {
  Future<List<Map<String, dynamic>>>? _futureDecks;

  Future<List<Map<String, dynamic>>> _fetchDecks() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final client = GraphQLProvider.of(context).value;

    print("INFO");
    print(appState.userInformation?["id"]);
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(getUserByIdQuery),
        variables: {"id": appState.userInformation?["id"]},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return (result.data?['getUserById']['folders'] as List? ?? [])
        .map((folder) => folder as Map<String, dynamic>)
        .toList();
  }

  void refetchDecks() {
    setState(() {
      _futureDecks = _fetchDecks();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_futureDecks == null) {
      setState(() {
        _futureDecks = _fetchDecks();
      });
    }

    final appState = Provider.of<AppState>(context);
    if (appState.deckUpdated) {
      refetchDecks();
      appState.resetDeckUpdated();
    } else {
      _futureDecks = _fetchDecks();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.redirectionOption == REDIRECT_OPTIONS.TO_EDIT_DECK
        ? "Seleccionar Mazo a editar"
        : "Seleccionar Mazo para jugar";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureDecks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final decks = snapshot.data ?? [];
            return Center(
              child: DeckList(decks, widget.redirectionOption,
                  widget.onNavigation, refetchDecks),
            );
          }),
    );
  }
}


/* 

  
 if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
  

   */