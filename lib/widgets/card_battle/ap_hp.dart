import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class ApHpText extends PositionComponent {
  String text;
  int cantidad;
  final double x;
  final double y;
  final Color backgroundColor;

  ApHpText({
    required this.text,
    required this.cantidad,
    required this.x,
    required this.y,
    this.backgroundColor = const Color(0xFF333333),
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this.position = Vector2(x, y);

    /* final Paint colorBackgroundPaint = Paint()..color = backgroundColor;
    final RRect colorBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 22.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(colorBackgroundRect, colorBackgroundPaint); */

    final Paint textBackgroundPaint = Paint()..color = backgroundColor;
    final RRect textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(26.0, 0, 36.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
    textPaint.render(canvas, '$text $cantidad', Vector2(30, 4));
  }
}

class ApHPInstances {
  late ApHpText apRival;
  late ApHpText hpRival;
  late ApHpText apPlayer;
  late ApHpText hpPlayer;

  ApHPInstances() {
    apRival = ApHpText(
      x: 620,
      y: 5,
      cantidad: 0,
      text: 'AP',
    );

    hpRival = ApHpText(
      x: 670,
      y: 5,
      cantidad: 0,
      text: 'HP',
    );

    apPlayer = ApHpText(
      x: 620,
      y: 370,
      cantidad: 0,
      text: 'AP',
    );

    hpPlayer = ApHpText(
      x: 670,
      y: 370,
      cantidad: 0,
      text: 'HP',
    );
  }

  updateValues(BattleCardGame battleCardGame) {
    apRival.cantidad = battleCardGame.rival.attackPoints;
    hpRival.cantidad = battleCardGame.rival.healthPoints;
    apPlayer.cantidad = battleCardGame.player.attackPoints;
    hpPlayer.cantidad = battleCardGame.player.healthPoints;
  }
}
