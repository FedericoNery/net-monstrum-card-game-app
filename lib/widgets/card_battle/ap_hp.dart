import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class ApHpText extends PositionComponent {
  String text;
  int cantidad;
  int _currentCantidad;
  int _targetCantidad;
  final double x;
  final double y;
  final Color backgroundColor;
  double _animationProgress = 0.0;
  double _animationDuration = 5.0; // Duración de la animación en segundos.
  double _elapsedTime = 0.0;

  ApHpText({
    required this.text,
    required this.cantidad,
    required this.x,
    required this.y,
    this.backgroundColor = const Color(0xFF333333),
  })  : _currentCantidad = cantidad,
        _targetCantidad = cantidad;

  void updateCantidad(int nuevaCantidad) {
    if (nuevaCantidad != _targetCantidad) {
      _animationProgress = 0.0;
      _animationDuration =
          nuevaCantidad.abs() - _targetCantidad.abs() > 50 ? 5.0 : 2.5;
      _elapsedTime = 0.0;
      _targetCantidad = nuevaCantidad;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_animationProgress < 1.0) {
      // Incrementa el tiempo transcurrido y calcula el progreso de la animación.
      _elapsedTime += dt;
      _animationProgress =
          (_elapsedTime / _animationDuration).clamp(0.0, _animationDuration);

      // Interpola entre el valor actual y el objetivo.
      _currentCantidad = (_currentCantidad +
              (_targetCantidad - _currentCantidad) * _animationProgress)
          .round();
    }
  }

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
    textPaint.render(canvas, '$text $_currentCantidad', Vector2(30, 4));
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
