import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ConfirmPhaseButton extends FlameGame {
  @override
  Future<void> onLoad() async {
    final defaultButton = DefaultButton("Confirm Phase");
    defaultButton.position = Vector2(50, 50);
    defaultButton.size = Vector2(250, 50);
    add(defaultButton);

/*     final disableButton = DisableButton();
    disableButton.isDisabled = true;
    disableButton.position = Vector2(400, 50);
    disableButton.size = defaultButton.size;
    add(disableButton);

    final toggleButton = ToggleButton();
    toggleButton.position = Vector2(50, 150);
    toggleButton.size = defaultButton.size;
    add(toggleButton); */
  }
}

/* class ToggleButton extends ToggleButtonComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    defaultLabel = TextComponent(
      text: 'Toggle button',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          color: BasicPalette.white.color,
        ),
      ),
    );

    defaultSelectedLabel = TextComponent(
      text: 'Toggle button',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          color: BasicPalette.red.color,
        ),
      ),
    );

    defaultSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 200, 0, 1));

    hoverSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 180, 0, 1));

    downSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 100, 0, 1));

    defaultSelectedSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 0, 200, 1));

    hoverAndSelectedSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 0, 180, 1));

    downAndSelectedSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 0, 100, 1));
  }
}
 */
class DefaultButton extends AdvancedButtonComponent with TapCallbacks {
  var tapUpCallback;
  String defaultText;

  DefaultButton(this.defaultText);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    defaultLabel = TextComponent(
        text: defaultText, size: Vector2.all(5), scale: Vector2.all(0.5));
    disabledLabel =
        TextComponent(text: 'Disabled button', size: Vector2.all(5));

    defaultSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 200, 0, 1));

    hoverSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 180, 0, 1));

    downSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 100, 0, 1));

    disabledSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(100, 100, 100, 1));
  }

  @override
  void onTapDown(_) {
    this.tapUpCallback();
  }

/*  @override
  void onTapUp(_) {
    this.tapUpCallback();
  }*/
}

/* class DisableButton extends AdvancedButtonComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    disabledLabel = TextComponent(text: 'Disabled button');

    defaultSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(0, 255, 0, 1));

    disabledSkin = RoundedRectComponent()
      ..setColor(const Color.fromRGBO(100, 100, 100, 1));
  }
} */

class RoundedRectComponent extends PositionComponent with HasPaint {
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        width,
        height,
        topLeft: Radius.circular(height),
        topRight: Radius.circular(height),
        bottomRight: Radius.circular(height),
        bottomLeft: Radius.circular(height),
      ),
      paint,
    );
  }
}

class InGameButton extends PositionComponent with TapCallbacks {
  final String defaultText;
  VoidCallback? tapUpCallback;

  late final TextComponent defaultLabel;
  late final RectangleComponent defaultSkin;
  late final RectangleComponent hoverSkin;
  late final RectangleComponent downSkin;
  late final RectangleComponent disabledSkin;

  InGameButton(this.defaultText, {this.tapUpCallback}) {
    size = Vector2(100, 30); // Tamaño del botón
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    defaultSkin = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = const Color(0xFF001F5A)
        ..style = PaintingStyle.fill,
    );

    final border = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    defaultLabel = TextBoxComponent(
      text: defaultText,
      anchor: Anchor.center,
      position: size / 2,
      boxConfig: TextBoxConfig(
        maxWidth: size.x - 20,
        timePerChar: 0.08,
        growingBox: true,
      ),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(defaultSkin);
    add(border);
    add(defaultLabel);
  }

  @override
  void onTapDown(_) {
    if (tapUpCallback != null) {
      tapUpCallback!();
    }
  }
}
