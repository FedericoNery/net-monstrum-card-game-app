import 'package:flutter/material.dart';

class MyButtonListWidget extends StatefulWidget {
  final List<String> roomsIds; // Parámetro que se pasará al widget

  // Constructor que acepta el parámetro
  MyButtonListWidget({required this.roomsIds});

  @override
  _MyButtonListWidgetState createState() => _MyButtonListWidgetState();
}

class _MyButtonListWidgetState extends State<MyButtonListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.roomsIds.length,
      itemBuilder: (BuildContext context, int index) {
        // Para cada elemento en la lista, crea un botón con el texto correspondiente
        return ElevatedButton(
          onPressed: () {
            // Acción a realizar cuando se presiona el botón
            print('Botón ${widget.roomsIds[index]} presionado');
          },
          child: Text(widget.roomsIds[index]), // Texto del botón
        );
      },
    );
  }
}
