import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/views/card_battle_multiplayer_view.dart';
import 'package:net_monstrum_card_game/views/deck_selector_view.dart';
import 'package:net_monstrum_card_game/views/home.dart';
import 'package:net_monstrum_card_game/views/store.dart';

class REDIRECT_OPTIONS {
  static const int TO_MULTIPLAYER = 0;
  static const int TO_EDIT_DECK = 1;
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  void _navigateToNewPageOutsideStack(BattleCardGame battleCardGame) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CardBattleMultiplayerView(
                battleCardGame: battleCardGame,
              )),
    );
  }

  final List<Widget> _screens = [];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomePage(),
      CardShop(),
      DeckSelectionScreen(
          redirectionOption: REDIRECT_OPTIONS.TO_EDIT_DECK,
          onNavigation: _navigateToNewPageOutsideStack),
      DeckSelectionScreen(
          redirectionOption: REDIRECT_OPTIONS.TO_MULTIPLAYER,
          onNavigation: _navigateToNewPageOutsideStack),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 1 && _selectedIndex != 2 && _selectedIndex != 3
          ? AppBar(
              title: const Text('Net Monstrum Card Game'),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex, // Cambia la vista según el índice seleccionado
        children: _screens, // Las pantallas que se cambiarán
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Editar mazo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Multiplayer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context)
            .primaryColor, // Color del ícono y texto seleccionados
        unselectedItemColor:
            Colors.grey, // Color de los íconos y textos no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}
