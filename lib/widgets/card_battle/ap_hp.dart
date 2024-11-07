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
  late TextComponent apRival;
  late TextComponent hpRival;
  late TextComponent apPlayer;
  late TextComponent hpPlayer;

  ApHPInstances() {
    apRival = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 0),
      scale: Vector2.all(0.8),
    );

    hpRival = TextComponent(
      text: 'HP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(700, 0),
      scale: Vector2.all(0.8),
    );

    apPlayer = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 370),
      scale: Vector2.all(0.8),
    );

    hpPlayer = TextComponent(
      text: 'HP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(700, 370),
      scale: Vector2.all(0.8),
    );
  }

  updateValues(BattleCardGame battleCardGame) {
    apRival.text = 'AP:${battleCardGame.rival.attackPoints}';
    hpRival.text = 'HP:${battleCardGame.rival.healthPoints}';
    apPlayer.text = 'AP:${battleCardGame.player.attackPoints}';
    hpPlayer.text = 'HP:${battleCardGame.player.healthPoints}';
  }
}
