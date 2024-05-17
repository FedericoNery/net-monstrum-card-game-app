import 'package:flutter/material.dart';

class DeckSelector extends StatefulWidget {
  final List<Map<String, String>> cards;
  //final Function(Map<String, String>) onSelect;

  DeckSelector({required this.cards
      //, required this.onSelect
      });

  @override
  _DeckSelectorState createState() => _DeckSelectorState();
}

class _DeckSelectorState extends State<DeckSelector> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < widget.cards.length; i++)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = i;
              });
              //widget.onSelect(widget.cards[i]);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedIndex == i ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                widget.cards[i]['name'] ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}
