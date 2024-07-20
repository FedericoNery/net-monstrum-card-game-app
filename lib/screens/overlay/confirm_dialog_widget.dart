import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/screens/card_battle_bloc.dart';
import 'package:net_monstrum_card_game/screens/card_battle_state.dart';


class ConfirmDialog extends World
  with HasGameRef, FlameBlocListenable<CardBattleBloc, CardBattleState> {

  ConfirmDialog();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final pauseOverlayIdentifier = 'PauseMenu';
  //game.overlays.remove(pauseOverlayIdentifier);
  }

@override
  void render(Canvas canvas) {
    super.render(canvas);

    // Dibuja el fondo azul
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(Rect.fromLTWH(5, 130, 300, 60), paint);

    // Dibuja el texto en la parte superior
    TextPainter(
      text: const TextSpan(
        text: 'Texto Superior',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: 200)
      ..paint(canvas, Offset(10, 10));

    // Dibuja los botones
    final buttonPaint = Paint()..color = Colors.lightBlue;
    canvas.drawRect(Rect.fromLTWH(10, 150, 130, 40), buttonPaint);
    canvas.drawRect(Rect.fromLTWH(160, 150, 130, 40), buttonPaint);

    // Dibuja el texto de los botones
    TextPainter(
      text: const TextSpan(
        text: 'Botón 1',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: 130)
      ..paint(canvas, Offset(30, 160));

    TextPainter(
      text: const TextSpan(
        text: 'Botón 2',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: 130)
      ..paint(canvas, Offset(180, 160));
  }

  @override
  bool onTapDown(TapDownInfo event) {
    final localCoords = event.eventPosition;

    // Detectar si se hizo clic en Botón 1
/*     if (Rect.fromLTWH(10, 150, 130, 40).contains(localCoords.toOffset())) {
      print('Botón 1 presionado');
      return true;
    }
 */
    // Detectar si se hizo clic en Botón 2
/*     if (Rect.fromLTWH(160, 150, 130, 40).contains(localCoords.toOffset())) {
      print('Botón 2 presionado');
      return true;
    }
 */
    return false;
  }
}
