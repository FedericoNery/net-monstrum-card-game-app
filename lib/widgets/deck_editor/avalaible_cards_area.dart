import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';
import 'package:net_monstrum_card_game/widgets/deck_editor/card_color.dart';

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
                      card.imageName.replaceAll(" ", "-"),
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
  }
}
