import 'package:flutter/material.dart';

import '../game/deck-selector.dart';

class MyButtonListWidget extends StatefulWidget {
  List<String> roomsIds; // Parámetro que se pasará al widget

  // Constructor que acepta el parámetro
  MyButtonListWidget({required this.roomsIds});

  @override
  _MyButtonListWidgetState createState() => _MyButtonListWidgetState();
}

class _MyButtonListWidgetState extends State<MyButtonListWidget> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cards = [
      {'id': '1', 'name': 'Card 1'},
      {'id': '2', 'name': 'Card 2'},
      {'id': '3', 'name': 'Card 3'},
    ];

    if (widget.roomsIds.length > 0) {
      return ListView.builder(
        itemCount: widget.roomsIds.length,
        itemBuilder: (BuildContext context, int index) {
          // Para cada elemento en la lista, crea un botón con el texto correspondiente
          return ElevatedButton(
            onPressed: () {
              // Acción a realizar cuando se presiona el botón
              print('Botón ${widget.roomsIds[index]} presionado');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeckSelector(cards: cards),
                  ));
            },
            child: Text(widget.roomsIds[index]), // Texto del botón
          );
        },
      );
    }

    return Text('La lista está vacía');
  }
}
