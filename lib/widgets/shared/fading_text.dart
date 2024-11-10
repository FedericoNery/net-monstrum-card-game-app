import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

mixin HasOpacityProvider on Component implements OpacityProvider {
  double _opacity = 1;
  Paint _paint = BasicPalette.white.paint();

  @override
  double get opacity => _opacity;

  @override
  set opacity(double value) {
    if (value == _opacity) return;
    _opacity = value;
    _paint = Paint()..color = Colors.white.withOpacity(value);
  }

  @override
  void renderTree(Canvas canvas) {
    canvas.saveLayer(null, Paint()..blendMode = BlendMode.srcOver);
    super.renderTree(canvas);
    canvas.drawPaint(_paint..blendMode = BlendMode.modulate);
    canvas.restore();
  }
}

class FadingTextComponent extends TextComponent with HasOpacityProvider {
  List<String> texts = [];
  final double screenWidth;
  final Color borderColor;
  final Color backgroundColor;
  // Definición del efecto de opacidad
  final OpacityEffect effect = OpacityEffect.to(
    0,
    EffectController(
      duration: 2,
    ),
  );

  FadingTextComponent({
    required this.screenWidth,
    this.borderColor = const Color(0xFF666666),
    this.backgroundColor = const Color.fromRGBO(8, 9, 56, 1),
    super.anchor,
    super.angle,
    super.children,
    super.priority,
    super.scale,
    super.size,
    super.position,
    super.textRenderer,
  }) {
    final myTextStyle = TextPaint(
      style: const TextStyle(
        fontSize: 48.0,
        color: Colors.white,
      ),
    );
    textRenderer = myTextStyle;

    // Configuración del efecto de opacidad
    effect.onComplete = onCompleteAnimation;
    effect.target = this;
    effect.removeOnFinish = false;

    this.position =
        Vector2(270, 180); // Puedes ajustar la posición según sea necesario */
  }

  @override
  void render(Canvas canvas) {
    if (text.isNotEmpty) {
      // Dibujar el fondo del texto, estirado a lo ancho de la pantalla
      final Paint backgroundPaint = Paint()..color = backgroundColor;
      final RRect backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(-500, 0, 1500, 60.0), // Fondo que ocupa todo el ancho
        Radius.circular(8.0),
      );
      canvas.drawRRect(backgroundRect, backgroundPaint);

      // Dibujar el borde del fondo
      final Paint borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(backgroundRect, borderPaint);

      super.render(canvas);
    }
  }

  @override
  set text(String value) {
    super.text = value;
    if (value.isNotEmpty) {
      add(effect);
      effect.apply(0);
      effect.reset();
    }
  }

  void onCompleteAnimation() {
    remove(effect);
    if (texts.isNotEmpty) {
      showNextMessage();
    } else {
      this.text = '';
    }
  }

  void showNextMessage() {
    if (texts.isNotEmpty) {
      this.text = texts.removeAt(0);
    }
  }

  void addText(String text) {
    texts.add(text);
    if (this.text.isEmpty) {
      showNextMessage();
    }
  }
}


/* class FadingTextComponent extends TextComponent with HasOpacityProvider {
  List<String> texts = [];
  OpacityEffect effect = OpacityEffect.to(
      0,
      EffectController(
        duration: 2,
      ));

  FadingTextComponent(
      {super.anchor,
      super.angle,
      super.children,
      super.priority,
      super.scale,
      super.size,
      super.position,
      super.textRenderer}) {
    effect.onComplete = onCompleteAnimation;
    effect.target = this;
    effect.removeOnFinish = false;
    this.position = Vector2(270, 180);
    final myTextStyle = TextPaint(
      style: const TextStyle(
        fontSize: 48.0,
        backgroundColor: Color.fromRGBO(8, 9, 56, 1),
        color: Colors.white, // Green color
      ),
    );
    textRenderer = myTextStyle;
  }

  @override
  set text(String value) {
    super.text = value;
    if (!value.isEmpty) {
      add(effect);
      effect.apply(0);
      effect.reset();
    }
  }

  void onCompleteAnimation() {
    remove(effect);
    if (texts.isNotEmpty) {
      showNextMessage();
    } else {
      this.text = '';
    }
  }

  void showNextMessage() {
    if (texts.isNotEmpty) {
      this.text = texts.removeAt(0);
    }
  }

  void addText(String text) {
    texts.add(text);
    if (this.text.isEmpty) {
      showNextMessage();
    }
  }
}
 */