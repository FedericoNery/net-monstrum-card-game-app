import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/views/deck_editor_view.dart';
import 'package:net_monstrum_card_game/views/deck_selector_view.dart';
import 'package:net_monstrum_card_game/views/home.dart';
import 'package:net_monstrum_card_game/views/socket_view.dart';
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

  // List of widgets (screens) to show based on the selected index
  final List<Widget> _screens = [
    HomePage(),
    CardShop(),
    DeckSelectionScreen(redirectionOption: REDIRECT_OPTIONS.TO_EDIT_DECK),
    DeckSelectionScreen(redirectionOption: REDIRECT_OPTIONS.TO_MULTIPLAYER),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Card Game Menu'),
        centerTitle: true,
      ), */
      body: IndexedStack(
        index: _selectedIndex, // Cambia la vista según el índice seleccionado
        children: _screens, // Las pantallas que se cambiarán
      ),
      bottomNavigationBar: _selectedIndex != 3
          ? BottomNavigationBar(
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
              selectedItemColor:
                  Colors.blue, // Color del ícono y texto seleccionados
              unselectedItemColor:
                  Colors.grey, // Color de los íconos y textos no seleccionados
              onTap: _onItemTapped,
            )
          : null,
      // Floating button for drawer
      floatingActionButton: _selectedIndex != 3
          ? FloatingActionButton(
              heroTag: 'fabUserInformation',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      child: const Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/50'),
                            ),
                            title: Text('Nivel 11'),
                            subtitle: Text('Progreso 75%'),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('Mensajes'),
                          ),
                          ListTile(
                            leading: Icon(Icons.card_giftcard),
                            title: Text('Regalos'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.account_circle),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
