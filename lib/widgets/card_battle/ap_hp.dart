import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class ApHpText extends PositionComponent {
  String text;
  int cantidad;
  int cantidadActual;
  int cantidadObjetivo;
  final double x;
  final double y;
  final Color backgroundColor;
  double progresoAnimacion = 0.0; // 1.0 sería el "100%" de la animación "completada"
  double duracionAnimacion = 5.0; 
  double tiempoEnCurso = 0.0;

  ApHpText({
    required this.text,
    required this.cantidad,
    required this.x,
    required this.y,
    this.backgroundColor = const Color(0xFF333333),
  })  : cantidadActual = cantidad,
        cantidadObjetivo = cantidad;

  void updateCantidad(int nuevaCantidad) {
    if (nuevaCantidad != cantidadObjetivo) {
      progresoAnimacion = 0.0;
      duracionAnimacion =
          nuevaCantidad.abs() - cantidadObjetivo.abs() > 50 ? 5.0 : 2.5;
      tiempoEnCurso = 0.0;
      cantidadObjetivo = nuevaCantidad;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (progresoAnimacion < 1.0) {
      tiempoEnCurso += dt;
      progresoAnimacion =
          (tiempoEnCurso / duracionAnimacion).clamp(0.0, duracionAnimacion);

      cantidadActual = (cantidadActual +
              (cantidadObjetivo - cantidadActual) * progresoAnimacion)
          .round();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this.position = Vector2(x, y);

    final Paint textBackgroundPaint = Paint()..color = backgroundColor;
    final RRect textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(26.0, 0, 46.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
    textPaint.render(canvas, '$text $cantidadActual', Vector2(30, 4));
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
    apRival.updateCantidad(battleCardGame.rival.attackPoints);
    hpRival.updateCantidad(battleCardGame.rival.healthPoints);
    apPlayer.updateCantidad(battleCardGame.player.attackPoints);
    hpPlayer.updateCantidad(battleCardGame.player.healthPoints);
  }
}
