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
        super.textRenderer}){
    effect.onComplete = onCompleteAnimation;
    effect.target = this;
    effect.removeOnFinish = false;

    final myTextStyle = TextPaint(
      style: TextStyle(
        fontSize: 24.0,
        color: const Color(0xFFFF0000), // Green color
      ),
    );
    textRenderer = myTextStyle;
  }

  @override
  set text(String value) {
    super.text = value;
    if(!value.isEmpty){
      add(effect);
      effect.apply(0);
      effect.reset();
    }
  }

  void onCompleteAnimation(){
    remove(effect);
    if (texts.isNotEmpty){
      showNextMessage();
    }
    else{
      this.text = '';
    }
  }

  void showNextMessage(){
    if (texts.isNotEmpty){
      this.text = texts.removeAt(0);
    }
  }

  void addText(String text){
    texts.add(text);
    if (this.text.isEmpty) {
      showNextMessage();
    }
  }
}