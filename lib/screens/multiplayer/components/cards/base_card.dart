import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/styles/flickering_card_border.dart';

abstract class BaseCardComponent<T extends Card> extends SpriteComponent {
  bool isHidden = false;
  double x = 0;
  double y = 0;
  bool isSelected = false;
  bool isRival = false;
  late T card;
  final shapeComponent = getFlickeringCardBorder();

  BaseCardComponent({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  void reveal();
  int getUniqueCardId();

  void deselectCardEffect() {
    if (isSelected) {
      isSelected = false;
      remove(shapeComponent);
//      children.first.add(RemoveEffect(delay: 0.1));
      update(1);
    }
  }

  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }
}
