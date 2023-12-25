import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

class ConfirmPhaseButton extends FlameGame {
  @override
  Future<void> onLoad() async {
    final defaultButton = DefaultButton();
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

  @override
  Future<void> onLoad() async {
    super.onLoad();

    defaultLabel = TextComponent(text: 'Summon Digimon', size: Vector2.all(5), scale: Vector2.all(0.5));
    disabledLabel = TextComponent(text: 'Disabled button', size: Vector2.all(5));

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

  @override
  void onTapUp(_) {
    this.tapUpCallback();
  }
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