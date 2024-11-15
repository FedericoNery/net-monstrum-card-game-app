import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

mixin HasOpacityProvider on Component implements OpacityProvider {
  double _opacity = 1;
  Paint _paint = Paint();

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

class FadingTextQueueComponent extends Component {
  final List<String> texts = [];
  final double screenWidth;
  final List<_FadingTextComponent> textComponents = [];
  final Paint backgroundPaint;
  final double textSize;
  final Color borderColor;
  final Gradient backgroundGradient;

  FadingTextQueueComponent({
    required this.screenWidth,
    this.borderColor = const Color(0xFF666666),
    this.textSize = 12.0,
  })  : backgroundGradient = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black12,
            Colors.black38,
            Colors.black54,
            Colors.black87,
            Colors.black.withOpacity(0)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        backgroundPaint = Paint();

  @override
  Future<void>? onLoad() async {
    backgroundPaint.shader = backgroundGradient.createShader(
      Rect.fromLTWH(0, 200, 200, 50),
    );
  }

  void addText(String text) {
    texts.add(text);
    _showNextMessage();
  }

  void _showNextMessage() {
    if (texts.isNotEmpty) {
      final newText = texts.removeAt(0);
      final textComponent = _FadingTextComponent(
        text: newText,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: textSize,
            color: Colors.white,
          ),
        ),
        position: Vector2(0, textComponents.length * 30.0 + 180),
      );
      textComponent.add(
        OpacityEffect.to(0, EffectController(duration: 2), onComplete: () {
          textComponents.remove(textComponent);
          _updateTextPositions();
          textComponent.removeFromParent();
        }),
      );
      add(textComponent);
      textComponents.add(textComponent);
    }
  }

  void _updateTextPositions() {
    for (var i = 0; i < textComponents.length; i++) {
      textComponents[i].position = Vector2(20, i * 30.0 + 100);
    }
  }

  @override
  void render(Canvas canvas) {
    for (var textComponent in textComponents) {
      final backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, textComponent.position.y, 200, 30),
        Radius.circular(4.0),
      );
      canvas.drawRRect(backgroundRect, backgroundPaint);

      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(backgroundRect, borderPaint);
    }
    super.render(canvas);
  }
}

class _FadingTextComponent extends TextComponent with HasOpacityProvider {
  _FadingTextComponent({
    required String text,
    required TextPaint textRenderer,
    required Vector2 position,
  }) : super(
          text: text,
          textRenderer: textRenderer,
          position: position,
        );
}
